#!/usr/bin/bash

path_to_emojis="$HOME/scripts/emoji_with_name.md"
choosed=$(cat "$path_to_emojis"| dmenu -p "Emojies:-" -l 7)

#copy the selected emoji to clipboard
echo $choosed | awk '{print$1" "}' | sed 's/ //'|tr -d '\n' | xclip -selection clipboard

if [ -n "$choosed" ];then
	#tag the selected emoji with recent for next time and remove olde recent tag
	cat $path_to_emojis| sed 's/ (recent)//' |sed "s/$choosed/$choosed (recent)/"  > temp.md && mv  temp.md $path_to_emojis
fi