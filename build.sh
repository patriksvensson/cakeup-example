#!/usr/bin/env bash
cake_version="0.25.0"
nuget_version="latest"
dotnet_version="1.1.7"
coreclr=false
bootstrap=true

# Fix up the script root.
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get the platform that we're running on.
uname_out="$(uname -s)"
case "${uname_out}" in
    Darwin*)    platform=osx;;
    *)          platform=linux
esac

# Make sure that cakeup exist.
cakeup_version="0.2.19"
cakeup="$script_dir/cakeup-x86_64-v$cakeup_version"
if [ ! -f "$cakeup" ]; then
    echo "Downloading cakeup..."
    curl -Lsfo $cakeup "https://cakeup.blob.core.windows.net/$platform/cakeup-x86_64-v$cakeup_version"
    if [ $? -ne 0 ]; then
        echo "An error occured while downloading cakeup."
        exit 1
    fi
fi

# Start Cake
exec $cakeup --cake="$cake_version" --nuget="$nuget_version" \
             --sdk="$dotnet_version" --coreclr="$coreclr" \
             --bootstrap="$bootstrap" --execute -- $@