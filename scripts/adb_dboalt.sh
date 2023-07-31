
adb_path=$(whereis adb)
if [[ ${#adb_path} -lt 3 ]]; then
	echo "Please Install Adb First"
	exit 1
fi

unins(){
	echo "By confirming this, you are confirming that any packages listed in in $1 are to be removed from your mobile and you take responsibility. (Y/n)"
	read ans
	echo "Your Choice $ans" 
	

	if [[ -n $(echo $ans | grep -iv "y" ) ]]; then
		echo "Exiting...."

	fi

	echo "Starting...."	
	for i in $(cat $1); do
		adb shell pm uninstall $i && echo "Sucessfully Deleted $i" || echo "Failed To delete $i";
	done;
}

unins $@
