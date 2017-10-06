#! /bin/sh

## Name: Shea Bunge
## Student ID: 407095
## 


# ensure that the records file exists before proceeding
if [ ! -f records ]
	then
	echo "the 'records' file must exist"
	exit 1
fi

# prints the records file to the screen
view_records() {
	cat records
}

# allows the user to search the records file with a specified keyword
search_records() {
	echo -e "Enter keyword: \c"
	read keyword

	if [ ! "$keyword" ]
		then
		echo "Keyword not entered"
	fi

	grep "$keyword" records
	if [ $? -ne 0 ]
		then
		echo "$keyword not found"
	fi
}

add_records() {
	echo 'Add New Employee Record'

	# prompt the user to enter a phone number
	while echo -e "Phone Number (xxxxxxxx): \c"
	do
		read phone
		case "$phone" in
			*[!0-9]*) echo 'Invalid phone number'; continue ;;
			'') echo 'Phone number not entered' ; continue ;;
			*) if grep "$phone" records >/dev/null; then echo "Phone number exists"; continue; else break; fi ;;
		esac
	done

	echo

	# prompt the user to enter their family name
	while echo -e "Family Name: \c"
	do
		read surname
		case "$surname" in
			*[!\ A-Za-z]*) echo "Family name can contain only alphabetic characters and spaces"; continue ;;
			'') echo 'Family name not entered' ; continue ;;
			*) break ;;
		esac
	done

	echo

	# prompt the user to enter their family name
	while echo -e "Given Name: \c"
	do
		read firstname
		case "$surname" in
			*[!\ A-Za-z]*) echo "Given name can contain only alphabetic characters and spaces"; continue ;;
			'') echo 'Given name not entered' ; continue ;;
			*) break ;;
		esac
	done

	echo

	# prompt the user to enter their department number
	while echo -e "Department Number: \c"
	do
		read firstname
		case "$surname" in
			*[!\ A-Za-z]*) echo "Given name can contain only alphabetic characters and spaces"; continue ;;
			'') echo 'Given name not entered' ; continue ;;
			*) break ;;
		esac
	done

}

delete_records() {
	echo 'Delete Employee Record'

	# read in the phone number of the record to delete
	echo -e "Enter a phone number: \c"
	read $phone


}

while true
do
	echo "
	Dominion Consulting Employees Info Main Menu
	============================================
	1 – Print All Current Records
	2 - Search for Specific Record(s)
	3 - Add New Records
	4 – Delete Records
	Q - Quit
	"

	echo -e "Your Selection: \c"
	read opt

	case $opt in
		1) view_records() ;;
		2) search_records() ;;
		3) add_records() ;;
		4) delete_records() ;;
		Q) exit 0 ;;
		*) echo 'Invalid selection'
	esac

	echo
	read -p 'Press Enter to continue...'

done
