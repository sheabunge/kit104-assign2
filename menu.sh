#!/bin/sh

## Written by Shea Bunge (student 407095) in Sept/Oct 2017
##
## This script assists with managing an employee records file
## It provides the functionality to view the records in full,
## search the records for a specified keyword, add new entries
## to the records, and delete entries from the records, all
## accessable from a menu interface


# ensure that the records file exists before proceeding
if [ ! -f records ]
	then
	# if it does not exist, display a message and exit the script
	echo "the 'records' file must exist"
	exit 1
fi

# helper function to wait for the user to press enter
confirm_continue() {
	echo
	read -p 'Press Enter to continue...'
}

# prints the records file to the screen
view_records() {
	cat records      # print the contents of the file
	confirm_continue # display a message before continuing
}

# allows the user to search the records file with a specified keyword
search_records() {

	# read in a keyword string from the user
	echo -e "Enter keyword: \c"
	read keyword

	# display a message if the keyword is empty
	if [ ! "$keyword" ]
		then
		echo 'Keyword not entered'
	else
		# search the records file for the specified keyword
		grep "$keyword" records

		# if the grep command found nothing, display a message
		if [ $? -ne 0 ]
			then
			echo "$keyword not found"
		fi
	fi

	# display a message before continuing
	confirm_continue
}

# helper function to read in a name from the user and validate it
# the first argument is the text to use for the prompt
# the second argument is the name of the field for use in error messages
# after running the function, the validated name will be stored in the $name variable
read_name() {

	# save the function arguments into variables
	prompt="$1"
	field="$2"

	# continually prompt for the name until it is entered
	while echo -e "$prompt: \c"
	do
		read name
		case "$name" in
			# display a message if the name contains invalid characters
			*[!\ A-Za-z]*) echo "$field can contain only alphabetic characters and spaces" ;;

			# display a message if the input is empty
			'') echo "$field not entered" ;;

			# otherwise, the name must be valid, so exit the loop
			*) break ;;
		esac
	done
	echo
}


# allows the user to add a new employee record to the records file
add_records() {
	# continually prompt the user to add a record until they decide to stop
	while true
	do
		echo 'Add New Employee Record'

		# continually prompt the user to enter a phone number until a valid one is entered
		while echo -e "Phone Number (xxxxxxxx): \c"
		do
			read phone
			case "$phone" in

				# display a message if the phone number is empty
				'') echo 'Phone number not entered' ;;

				# check if the phone number is valid (eight digits not beginning with a zero)
				[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
					# if valid, use grep to determine whether it already exists in the records file
					if grep "$phone" records >/dev/null;
						then
						# if it does exist, then display a message and allow the loop to continue
						echo 'Phone number exists'
					else
						# if it is valid and does not already exist, then break out of the loop
						break
					fi
					;;

				# if the phone number does not match the above pattern, then it is invalid
				# diplay a message and allow the loop to continue
				*) echo 'Invalid phone number' ;;
			esac
		done

		echo

		# prompt the user to enter the employee's family name
		read_name 'Family Name' 'Family name'
		surname="$name"

		# prompt the user to enter the employee's first name
		read_name 'Given Name' 'Given name'
		firstname="$name"

		# continually prompt the user to enter a departmetn number until a valid one is entered
		while echo -e "Department Number: \c"
		do
			read depnum
			case "$depnum" in
				# exit the loop if the department number is valid (exactly two digits)
				[0-9][0-9]) break ;;

				# display a message if the input is empty
				'') echo 'Department number not entered' ;;

				# otherwise, the department number must be invalid, so display a message
				*) echo 'A valid department number contains 2 digits' ;;
			esac
		done

		echo

		# prompt the user to enter the employee's job title
		read_name 'Job Title' 'Job title'
		title="$name"

		# add the new information to the records file
		echo 'Adding new employee record to the records file ...'
		echo "$phone:$surname:$firstname:$depnum:$title" >> records && echo 'New record saved'
		echo

		# ask the user whether to continue the loop or exit
		echo -e "Add another? (y)es or (n)o: \c"
		read YN
		case "$YN" in
			# if the user entered 'n', break out of the loop and return to the menu
			[Nn]*) echo; break ;;
			# if the user entered 'y', allow the loop to continue
			[Yy]*) echo ;;
			# if the user entered something else, display a message and then return to the menu
			*) echo 'Invalid response - returning to menu'; break; ;;
		esac
	done
}

delete_records() {
	echo 'Delete Employee Record'

	# read in the phone number of the record to delete
	while echo -e "Enter a phone number: \c"
	do
		read phone
		case "$phone" in

			# display a message if the phone number is empty
			'') echo 'Phone number not entered' ;;

			# check if the phone number is valid (eight digits not beginning with a zero)
			[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
				if grep "$phone" records >/dev/null;
					then
					break
				else
					echo 'Phone number not found'
				fi
				;;

			# if the phone number does not match the above pattern, then it is invalid
			*) echo 'Invalid phone number' ;;
		esac
	done

	grep "$phone" records

	# ask the user whether to continue the loop or exit
	echo -e "\nConfirm deletion: (y)es or (n)o: \c"
	read YN
	case "$YN" in
		# if the user entered 'n', do nothing and allow the function to return to the main menu
		[Nn]*) break ;;
		# if the user entered 'y', perform the deletion
		[Yy]*)
			# use grep to remove the record to be deleted and save output to a temporary file
			# it is not possible to write the output directly back into records due to how bash handles redirections
			grep -v "$phone" records > records.tmp
			cat records.tmp > records # write the temporary file contents back into the records file.
			rm -f records.tmp         # remove the temporary file
			;;
		# if the user entered something else, display a message and then return to the menu
		*) echo 'Invalid response – returning to menu' ;;
	esac
}

# continue to display the menu until the program is exited
while true
do
	# display the menu
	echo "
Dominion Consulting Employees Info Main Menu
============================================
1 – Print All Current Records
2 - Search for Specific Record(s)
3 - Add New Records
4 – Delete Records
Q - Quit
"

	# prompt the user to enter their selection
	echo -e "Your Selection: \c"
	read opt

	# execute the appropriate function for the user's selection
	case $opt in
		1) view_records ;;
		2) search_records ;;
		3) add_records ;;
		4) delete_records ;;
		Q|q) exit 0 ;;
		*) echo 'Invalid selection'; confirm_continue ;;
	esac
done
