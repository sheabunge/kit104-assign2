#!/bin/sh

## Written by Shea Bunge (student 407095) in Oct 2017
##
## This script works with a blacklist of usernames stored in
## a file named user.deny, with one username per line
##
## at three second intervals, a message is displayed for each user on
## the blacklist who has more than one active login session

# ensure that the user.deny file exists before proceeding
if [ ! -f user.deny ]
	then
	# if it does not exist, display a message and exit the script
	echo "the 'user.deny' file must exist under the current directory"
	exit 1
fi

# read the contents of the user.deny file into a variable
deny=`cat user.deny`

# continually loop until the script is aborted
while true
do
	# use this variable to determine whether any blacklisted users with
	# multiple logins have been discovered
	found=0

	# loop through every user on the deny list
	for user in $deny
	do
		# run the who command to retrieve a list of all logged-in users and then
		# filter it to only display entries for the specified user names
		# if the result is more than one line, then the user has multiple logins
		if [ `who | grep $user | wc -l` -gt 1 ]
			then
			# determine the user's full name using grep to find the relevant line in
			# /etc/passwd, and then using cut to retrieve the fifth column
			fullname=`grep -P "^$user:" /etc/passwd | cut -f5 -d:`

			# display a message to say that the user has multiple logins
			echo
			echo "The user $fullname (on the denial list) has logged in more than once!"

			# as we have discovered a user with multiple logins, set the found variable to 1
			found=1
		fi
	done

	# check if the found variable is still equal to zero
	# if it is, then it means that no users have been discovered with multiple logins
	if [ $found -eq 0 ]
		then
		# display a message if the found variable is unchanged
		echo
		echo "No user on the user.deny list has multiple logins"
	fi

	# wait for three seconds before returning to the top of the loop
	sleep 3
done
