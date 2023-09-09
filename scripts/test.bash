meetingDate="$(date +'%Y/%m/%d')"
reminderDate=`date --date=$meetingDate'-1 day' +'%Y/%m/%d'`
dir="$base_dir/$reminderDate"
echo $reminderDate $dir
# jus a tstd aw wd	
