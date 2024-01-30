#! /bin/bash

# If no directory provided, use current directory
if [ -z "$1" ]; then
    directory="."
else
    directory="$1"
fi

# Check if directory provided exists
if [ ! -d "$directory" ]; then
    echo "Error: $directory does not exist"
    exit 1
fi

# Get absolute path of directory
directory="$(cd "$(dirname "$directory")"; pwd)/$(basename "$directory")"

# Declare array of file extensions and directories to remove
declare -a REMOVE=(
    ".DS_Store"
    ".class"
    "__pycache__"
    ".pyc"
    ".exe"
    ".out"
    ".o"
)

# Loop through array, remove found files and directories
for i in "${REMOVE[@]}"
do
    echo "Deleting *$i files..."
    find -L "$directory" -name "*$i" -exec sh -c 'echo "Deleted" $1; rm -rf $1' _ {} \;
    echo
done
echo "Successfully cleaned $directory"