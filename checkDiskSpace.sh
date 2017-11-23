#!/bin/bash

# Function for Telegram to send warning
telegram() {
	telegramGroupID="";
	botToken="";
	if [ -n "${telegramGroupID}" ] && [ -n "${botToken}" ]; then
		timeout="10";
		url="https://api.telegram.org/bot${botToken}/sendMessage";
		message="${*}";

		# Send login notification to Telegram group
		curl -s --max-time ${timeout} -d "chat_id=${telegramGroupID}&disable_web_page_preview=1&parse_mode=markdown&text=${message}" ${url} >/dev/null
	else
		echo -e "\nSet Telegram bot options 'telegramGroupID' & 'botToken' variables if you want Telegram notifications to be active\n";
	fi;
};

# Set alert percentage level (eg 85)
ALERT=85;
df -PH | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $1}' | while read output; do
	usep=$(echo $output | awk '{print $1}' | cut -d '%' -f1);
	partition=$(echo $output | awk '{print $2}');
	[ ${usep} -ge ${ALERT} ] && telegram "Running out of space ${partition} (${usep}%) on $(hostname)";
done;
