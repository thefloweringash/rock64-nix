#!/usr/bin/env nix-shell
#! nix-shell -i bash -p ruby -p curl -p nix-prefetch-scripts

set -e
set -o pipefail

# nix-shell sets TMPDIR to be /run/user/1000 (wat). Which is a small
# tmpfs that is not big enough to checkout linux. nix-prefetch-git has
# sensible defaults, so let's just use those instead.
unset TMPDIR

version="$1"

if [ -z "$version" ]; then
    echo "Required argument missing"
    echo "Usage: $0 version"
    exit
fi

indent() {
    while read; do
        echo "  $REPLY";
    done
}

format_prefetch() {
    local name="$1"
    local rev="$2"
    local sha256="$3"
    echo "$1 = {";
    cat <<EOF | indent
rev = "$rev";
sha256 = "$sha256";
EOF
    echo "};"
}

projects="$(
curl -L https://raw.githubusercontent.com/ayufan-rock64/linux-manifests/default/default.xml | \
    ruby -r rexml/document -e 'puts REXML::Document.new(STDIN).elements.collect("//project") { |p| p.attribute("name").value }'

)"

(
echo "{"
echo "version = \"${version}\";" | indent

for project in $projects; do
    url="https://github.com/ayufan-rock64/${project}"
    rev="ayufan-rock64/linux-build/${version}"
    cache="prefetch-${project}-${version}";
    fetch_url="$url/archive/$rev.tar.gz"

    # linux-build is the meta project
    # rkbin isn't tagged (why?)
    if [[ "$project" == linux-build || "$project" == rkbin ]]; then
        continue
    fi

    sha256=$(
        if [ -f $cache ]; then
            cat "$cache"
        else
            echo "Prefetching: $project @ ${rev}" >&2
            tmpcache="$(mktemp -p $PWD -t prefetch-XXXXXX)"

            if nix-prefetch-url --unpack --name source $fetch_url | tee $tmpcache; then
                mv $tmpcache $cache
            else
                rm $tmpcache
            fi
        fi
    )

    format_prefetch $project $rev $sha256
done | indent
echo "}"
) | tee ayufan-rock64-sources.nix
