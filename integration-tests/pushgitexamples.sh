#!/bin/bash

# filepath = realpath 100.json

yes | cp -i 100.json /var/git/repos/GitOperatorTestRepo/100.json

cd /var/git/repos/GitOperatorTestRepo

git add 100.json

git commit -m "Prepared example file"

git push origin master