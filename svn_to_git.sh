#!/bin/bash

echo "1. Setup attributes"
TEMP=`pwd`/new_temp
AUTHORS=`pwd`/authors-transform.txt
SVN="https://example.com/svn/repo_name"
GIT="https://example.com/repo/path/name.git"

echo "TEMP: $TEMP"
echo "AUTHORS: $AUTHORS"
echo "SVN: $SVN"
echo "GIT: $GIT"

echo "2. Clone the Subversion repository using git-svn"
rm -rf $TEMP
git svn clone $SVN --no-metadata -A $AUTHORS --stdlayout $TEMP

echo "3. Clean up remote absent branches"
cd $TEMP
git for-each-ref --format='%(refname)' refs/remotes/origin/origin | cut -d / -f 3- |
while read ref
do
  git branch -dr "$ref";
done

echo "4. Create tags and clean up branches under /tags/ path"
git for-each-ref --format='%(refname)' refs/remotes/origin/tags | cut -d / -f 5 |
while read ref
do
  git tag "$ref" "refs/remotes/origin/tags/$ref";
  git branch -dr "origin/tags/$ref";
done

echo "5. Setup push for remote"
git config remote.origin.push 'refs/remotes/*:refs/heads/*'

echo "6. Update predefined origin"
git remote set-url origin $GIT

echo "7. Publish to Git repository branches and tags"
git push
git push --tags

echo "8. Clean up temp folder"
rm -rf $TEMP