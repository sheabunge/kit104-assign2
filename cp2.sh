#!/bin/sh

## Written by Shea Bunge (student 407095) in Sept/Oct 2017
##
## This script copies all the files from two directories into a newly-created destination directory
## If there are duplicate files between the two source directories, the most recently modified files will be kept
## The destination directory will be created by the script, and should not already exist

# ensure that the directories exist. if not, display an error and exit
if [ ! -d $1 ] || [ ! -d $2 ]
	then
	echo -e "the directories $1 and $2 must already exist"
	exit 1
fi

# create the destination directory
mkdir "$3"

# output the files in the first group - these will all be copied
echo "These files from $1 copied into $3:"
ls -A "$1"
echo

# copy all files from the first directory to the empty destination, maintaining file attributes
cp -p $1/* "$3"

# output the files that only exist in the second group
echo "These new file(s) from $2 copied into $3:"

# loop through all files in dir2
for file in $(ls -1 $2)
do
	# make sure the file does not already exist in dir3
	if [ ! -f $3/$file ]
	then
		# if so, output the filename only
		echo $file
	fi
done

# output a newline to separate the sections
echo

# output the files that exist in both groups and will be overridden
echo "These file(s) from $2 copied into $3 and overwrite(s) their namesakes in $3:"

# loop through all files in dir2
for file in $(ls -1 $2)
do
	# if the file already exists in dir3, check whether the file in dir2 is newer
	if [ -f $3/$file ] && [ $2/$file -nt $3/$file ]
		then
		# if so, output the filename only
		echo $file
	fi
done

# copy all files from the second directory to the destination, maintainign file atrributes
# and only overwriting files if the source file is newer than the destination
cp -p --update $2/* "$3"
