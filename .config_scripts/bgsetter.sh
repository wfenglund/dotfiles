## In order for this script to work, you also have to add the line
# /bin/bash ~/.config_scripts/bgsetter.sh &
## to your .xprofile, and the following lines to your ~/.i3/config
# set $ws1 "1:Hartnell"
# set $ws2 "2:Troughton"
# set $ws3 "3:Pertwee"
# set $ws4 "4:Baker1"
# set $ws5 "5:Davison"
# set $ws6 "6:Baker2"
# set $ws7 "7:McCoy"
# set $ws8 "8:McGann"

old_ws="blank"

while true
do
	current_ws=$(/bin/i3-msg -t get_workspaces | /home/william/anaconda3/bin/jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
	if [[ $current_ws != $old_ws ]]
	then
		if [[ $current_ws == "1:Hartnell" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_1/*
		elif [[ $current_ws == "2:Troughton" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_2/*
		elif [[ $current_ws == "3:Pertwee" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_3/*
		elif [[ $current_ws == "4:Baker1" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_4/*
		elif [[ $current_ws == "5:Davison" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_5/*
		elif [[ $current_ws == "6:Baker2" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_6/*
		elif [[ $current_ws == "7:McCoy" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_7/*
		elif [[ $current_ws == "8:McGann" ]]
		then
			feh --bg-fill --randomize ~/Bilder/backgrounds/doctor_8/*
		fi
	fi
	old_ws=$current_ws
done
