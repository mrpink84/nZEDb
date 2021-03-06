# This script will check the number of connections to your USP, and display it on the powerline bar in tmux.


##############
# Make sure you edit the path to the config.php file to reflect your install!!
##############


run_segment() {
	# get USP settings from config.php
	uspsetting=( $(cat ../../../../www/config.php | awk '/NNTP/ && /SERVER|PORT/ {print $2}' | sed 's/);//' | sed "s/'//g") )

	# Get info about primary NNTP connections.
	mainusp=( $(dig ${uspsetting[0]} | awk '/   A   / {print $5}') )
	grepusp=$(echo "${mainusp[@]}" | sed 's/ /|/g')
	maincount=$(ss -n | awk '{printf"%s %s\n",$1,$5}' | egrep "$grepusp" | grep -c ${uspsetting[1]})

	# Check to see if have we an alternate USP set, if so get those connections too.
	if [[ -n "${uspsetting[3]}" ]]; then
		altusp=( $(dig ${uspsetting[2]} | awk '/    A   / {print $5}') )
		grepausp=$(echo "${altusp[@]}" | sed 's/ /|/g')
		altcount=$(ss -n | awk '{printf"%s %s\n",$1,$5}' | egrep "$grepausp" | grep -c ${uspsetting[3]})

	# Print results to powerline.
		echo "MainUSP: $altcount, AltUSP: $maincount"
	else
		echo "MainUSP: $maincount"
	fi

}
