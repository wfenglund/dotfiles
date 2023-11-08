current_ws=$(/bin/i3-msg -t get_workspaces | /home/william/anaconda3/bin/jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)

echo "thisworked" > ~/output.test

while true
do
	current_ws=$(/bin/i3-msg -t get_workspaces | /home/william/anaconda3/bin/jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
	echo $current_ws >> ~/output.test
	if [[ $current_ws == "1:Hartnell" ]]
	then
		feh --bg-fill ~/Bilder/doctor_1.jpg
	elif [[ $current_ws == "2:Throughton" ]]
	then
		feh --bg-fill ~/Bilder/doctor_2.jpg
	elif [[ $current_ws == "3:Pertwee" ]]
	then
		feh --bg-fill ~/Bilder/doctor_3.jpg
	elif [[ $current_ws == "4:Baker1" ]]
	then
		feh --bg-fill ~/Bilder/doctor_4.jpg
	elif [[ $current_ws == "5:Davison" ]]
	then
		feh --bg-fill ~/Bilder/doctor_5.jpg
	elif [[ $current_ws == "6:Baker2" ]]
	then
		feh --bg-fill ~/Bilder/doctor_6.jpg
	elif [[ $current_ws == "7:McCoy" ]]
	then
		feh --bg-fill ~/Bilder/doctor_7.jpg
	elif [[ $current_ws == "8:McGann" ]]
	then
		feh --bg-fill ~/Bilder/doctor_8.jpg
	fi
done
