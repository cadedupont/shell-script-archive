#! /bin/bash

# Make sure clean script exists and is executable
if [ ! -x "$(command -v clean.sh)" ]; then
    echo "Error: clean script not found or not executable"
    exit 1
fi

# Run clean script on programs directory to remove unnecessary files before transfer
clean.sh ~/Programs

# Declare array to store files and directories to be ignored by rsync operations
declare -a IGNORE=(
    ".git"
    ".gitignore"
    ".gitmodules"
    "LICENSE"
    ".vscode"
    "node_modules"
    "dist"
    "build"
    "target"
)

# Add each file and directory to be ignored to the rsync ignore list
IGNORE_LIST=$(printf " --exclude %s" "${IGNORE[@]}")

# Transfer files to Turing; ignore "public" directory so it can be transferred separately to different location
rsync -avz --copy-links --checksum --delete --exclude public $IGNORE_LIST ~/Programs/University/* turing:~/Programs/University/
rsync -avz --copy-links --checksum --delete --exclude public $IGNORE_LIST ~/Programs/Personal/* turing:~/Programs/Personal/
rsync -avz --copy-links --checksum --delete $IGNORE_LIST ~/Programs/University/public/* turing:~/public_html/

# Set correct permissions on files and directories in Turing
ssh turing << EOF
    chmod 701 ~
    find ~/Programs -type d -exec chmod 700 {} + && find ~/Programs -type f -exec chmod 600 {} +
    chmod -R 755 ~/public_html
EOF