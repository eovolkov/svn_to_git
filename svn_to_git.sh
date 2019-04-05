#!/bin/bash
TEMP=`pwd`/new_temp
AUTHORS=`pwd`/authors-transform.txt
SVN="https://example.com/svn/repo_name"
GIT="https://example.com/repo/path/name.git"
HEAD_BRANCH="master"


echo "TEMP: $TEMP"
echo "AUTHORS: $AUTHORS"
echo "SVN: $SVN"
echo "GIT: $GIT"

echo "1. Clone the Subversion repository using git-svn"
rm -rf $TEMP
git svn clone $SVN --preserve-empty-dirs --no-metadata -A $AUTHORS --stdlayout $TEMP

echo "2. Clean up remote absent branches"
cd $TEMP
git for-each-ref --format='%(refname)' refs/remotes/origin/origin | cut -d / -f 3- |
while read ref
do
  git branch -dr "$ref";
done

echo "3. Create tags and clean up branches under /tags/ path"
git for-each-ref --format='%(refname)' refs/remotes/origin/tags | cut -d / -f 5 |
while read ref
do
  git tag "$ref" "refs/remotes/origin/tags/$ref";
  git branch -dr "origin/tags/$ref";
done

echo "4. Create local branches from remote"
git for-each-ref --format='%(refname)' refs/remotes/origin | cut -d / -f 2- |
while read ref
do
  branch_name=`echo "$ref" | cut -d / -f 3`
  git checkout -b $branch_name --track $ref
done

echo "5. Remote predefined origin and add new one"
git remote remove origin
git remote add origin $GIT

echo "6. Set head branch"
git symbolic-ref HEAD refs/heads/$HEAD_BRANCH

echo "7. Publish to Git repository branches and tags"
git push -u origin --all
git push -u origin --tags

echo "8. Clean up temp folder"
rm -rf $TEMP