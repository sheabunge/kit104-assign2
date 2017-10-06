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
		echo "Keyword not entered"
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

# allows the user to add a new employee record to the records file
add_records() {
	# continually prompt the user to add a record until they decide to stop
	while true
	do
		echo 'Add New Employee Record'

		# prompt the user to enter a phone number
		while echo -e "Phone Number (xxxxxxxx): \c"
		do
			read phone
			case "$phone" in

				# display a message if the phone number is empty
				'')
					echo 'Phone number not entered'
					continue ;;

				# check if the phone number is valid (eight digits not beginning with a zero)
				[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
					if grep "$phone" records >/dev/null;
						then
						echo "Phone number exists"
						continue
					else
						break
					fi
					;;

				# if the phone number does not match the above pattern, then it is invalid
				*)
					echo 'Invalid phone number'
					continue ;;
			esac
		done

		echo

		# prompt the user to enter their family name
		while echo -e "Family Name: \c"
		do
			read surname
			case "$surname" in
				# display a message if the input contains invalid characters
				[!\ A-Za-z]*) echo "Family name can contain only alphabetic characters and spaces" ;;

				# display a message if the family name is empty
				'') echo 'Family name not entered' ;;

				# otherwise, the family name must be valid, so exit the loop
				*) break ;;
			esac
		done

		echo

		# prompt the user to enter their family name
		while echo -e "Given Name: \c"
		do
			read firstname
			case "$firstname" in
				# display a message if the input contains invalid characters
				[!\ A-Za-z]*) echo "Given name can contain only alphabetic characters and spaces" ;;

				# display a message if the family name is empty
				'') echo 'Given name not entered' ;;

				# otherwise, the given name must be valid, so exit the loop
				*) break ;;
			esac
		done

		echo

		# prompt the user to enter their department number
		while echo -e "Department Number: \c"
		do
			read depnum
			case "$depnum" in
				# display a message if the input contains invalid characters
				![0-9][0-9]) echo 'A valid department number contains 2 digits' ;;

				# display a message if the input is empty
				'') echo 'Department name not entered' ;;

				# otherwise, the department number must be valid, so exit the loop
				*) break ;;
			esac
		done

		echo

		# prompt the user to enter their job title
		while echo -e "Job Title: \c"
		do
			read title
			case "$title" in
				# display a message if the input contains invalid characters
				[!\ A-Za-z]*) echo "Job title can contain only alphabetic characters and spaces" ;;

				# display a message if the family name is empty
				'') echo 'Job title not entered' ;;

				# otherwise, the job title must be valid, so exit the loop
				*) break ;;
			esac
		done

		# add the new information to the records file
		echo
		echo 'Adding new employee record to the records file ...'
		echo "$phone:$surname:$firstname:$depnum:$title" >> records
		echo 'New record saved'

		# ask the user whether to continue the loop or exit
		echo -e "Add another? (y)es or (n)o: n \c"
		read YN
		case "$YN" in
			# if the user entered 'n', break out of the loop and return to the menu
			n|n) echo; break ;;
			# if the user entered 'y', do nothing (i.e. allow the loop to continue)
			n|N) echo ;;
			# if the user entered something else, display a message and then return to the menu
			*) echo 'Invalid response - returning to menu'; break; ;;
		esac
	done
}

delete_records() {
	echo 'Delete Employee Record'

	# read in the phone number of the record to delete
	echo -e "Enter a phone number: \c"
	read $phone


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
