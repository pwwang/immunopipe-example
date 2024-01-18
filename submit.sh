#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <commit message>"
    exit 1
fi

rm -rf .git/
git init
git add .
git commit -m "$1"
git remote add origin https://github.com/pwwang/immunopipe-example.git
git push -u --force origin master
