#!/usr/bin/env sh

# do we need to copy dotfiles?
# do we need to display an error if copy failed?
# do we copy directories (recusrively) or just files?
# do we follow or copy symlinks?
# do we need to preserve file permissions/ownership


# ensure that the directories exist
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

# create the destination directory and copy the files
mkdir "$3"
cp -r "$1/." "$3"
cp -r "$2/." "$3"
