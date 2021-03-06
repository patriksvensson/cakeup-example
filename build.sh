#!/usr/bin/env bash
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
tools_dir=$script_dir/tools

# Get the platform that we're running on.
if [ -f /.dockerenv ]; then
    platform="linux-musl"
else
    uname_out="$(uname -s)"
    case "${uname_out}" in
        Darwin*)    platform=osx;;
        *)          platform=linux
    esac
fi

# Make sure that cakeup exist.
cakeup="$tools_dir/cakeup-x86_64-latest"
if [ ! -f "$cakeup" ]; then
    echo "Downloading cakeup..."
    curl -Lsfo $cakeup "https://cakeup.blob.core.windows.net/$platform/cakeup-x86_64-latest"
    if [ $? -ne 0 ]; then
        echo "An error occured while downloading cakeup."
        exit 1
    fi
    chmod +x "$cakeup"
fi

# Start Cake
exec $cakeup run --cake="0.26.1" --nuget="latest" \
                 --sdk="2.1.4" --coreclr \
                 --bootstrap --execute -- $@