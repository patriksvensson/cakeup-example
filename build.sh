#!/usr/bin/env bash
cake_version="0.25.0";
nuget_version="latest";
dotnet_version="none";
coreclr=false;
bootstrap=true;

# Fix up the script root.
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Make sure that cakeup exist.
cakeup=$script_dir/cakeup
if [ ! -f "$cakeup" ]; then
    echo "Downloading cakeup..."
    curl -Lsfo $cakeup https://github.com/patriksvensson/cakeup-example/releases/download/v0.4.0/cakeup
    if [ $? -ne 0 ]; then
        echo "An error occured while downloading cakeup."
        exit 1
    fi
fi

# Start Cake
exec $cakeup --cake="$cake_version" --nuget="$nuget_version" \
             --sdk="$dotnet_version" --coreclr="$coreclr" \
             --bootstrap="$bootstrap" --execute -- $@