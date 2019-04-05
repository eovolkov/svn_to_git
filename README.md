# SVN to Git migration

Such migration supposes transformation SVN repository to Git. 

When all required steps will finished, transformed data will be published to remote git repository.

## Table of Contents
* [Control Machine Requirements](#control-machine-requirements)
* [Predefined attributes](#predefined-attributes)
* [Preparation](#preparation)
* [Handled steps](#handled-steps)
* [Launch script](#launch-script)

### Control Machine Requirements
Code located in this repository has several requirements:
- Any Linux based OS
- SVN
- Git
- bash
- Access to svn and git repositories

This code was successfully tested with:
- MacOs Sierra 10.12.6
- SVN 1.9.4
- Git 2.21.0

### Predefined attributes
We have several predefined variables:

- TEMP - folder path where will be saved data from svn repository  
- AUTHORS - path to config file which contains predefined matching with svn and git authors   
- SVN - URL to svn repository
- GIT - URL ti git repository
- HEAD_BRANCH - default branch for git repo

### Preparation
1\. We should already have installed svn and git.

2\. Clone svn repository in TEMP folder
```
svn checkout $SVN $TEMP
```
3\. Prepare AUTHORS file
```
cd $TEMP
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > ../authors-transform.txt
```
4\. Remove TEMP folder
```
cd ..
rm -rf $TEMP
```

### Handled steps
1\. Setup attributes
```
TEMP=[path to temp folder]
AUTHORS=[path to file authors-transform.txt]
SVN=[URL to svn repo like "https://example.com/svn/repo_name"]
GIT=[URL to git repo like "https://example.com/repo/path/name.git"]
HEAD_BRANCH="[default branch name]"
```

2\. Clone the Subversion repository using git-svn

3\. Clean up remote absent branches if presents

4\. Create tags and clean up branches under /tags/ path

5\. Create local branches from remote

6\. Remote predefined origin and add new one. Remote branches will be removed automatically.

7\. Set head branch

8\. Publish to Git repository branches and tags

9\. Clean up temp folder

### Launch script
Script developed to launch with bash.
```
bash svn_to_git.sh
``` 