#!/bin/sh

## Written by Shea Bunge (student 407095) in Sept/Oct 2017
## 
## This script copies all the files from two directories into a newly-created destination directory
## If there are duplicate files between the two source directories, the newest files will be kept
## The destination directory will be created by the script, and should not already exist

# ensure that the directories exist. if not, display an error and exit
if [ ! -d $1 ] || [ ! -d $2 ]
	then
	echo -e "the directories $1 and $2 must already exist"
	exit 1
fi

# output the files in the first group - these will all be copied
echo "These files from $1 copied into $3:"
ls -A "$1"
echo

# output the files that only exist in the second group
echo "These new file(s) from $2 copied into $3:"

for file in $(ls -1 $2)
do
	if [ ! -f $1/$file ]
	then
		echo $file
	fi
done

echo

# output the files that exist in both groups and will be overridden
echo "These file(s) from $2 copied into $3 and overwrite(s) their namesakes in $3:"

for file in $(ls -1 $2)
do
	if [ -f $1/$file ]
		then
		echo $file
	fi
done

# create the destination directory
mkdir "$3"

# copy all files from the first directory to the empty destination
cp -r "$1/." "$3"
cp -r "$2/." "$3"
