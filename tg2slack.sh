#!/bin/bash
## Telegram to Slack bridge - this script uses two commandline tools to talk to Telegram and Slack.
## Copyrigth Sooraj Raveendran, 2015

# CHANGEME:
# The pattern you want to look for in the telegram messages.
# E.g. if you are reading messages from a group named OFFICEBUDDIES, replace MY_CHAT_GROUP with OFFICEBUDDIES below
export PATTERN="[0-9]\+\s\[.\+\]\s\sMY_CHAT_GROUP"

# CHANGEME:
# The place where you are keeping the code for this TG-Slack bridge
export BRIDGE_PATH /home/ubuntu/tg2slack


cd $BRIDGE_PATH

# Download all the chat since we grabbed them last tg app keeps track of how much we read previously
expect ./telegram-slack-bridge/get_chat.expect 2>&1 > session.log
## Read messages from telegram-cli logs and post to Slack
## We remove the special characters
cat session.log | ansi2txt | grep $PATTERN | sed -n "/$PATTERN/s/$PATTERN//p" > processed.txt
export CHAT_LINES=`cat processed.txt | wc -l`
if [ $CHAT_LINES -gt 0 ]; then
    cat processed.txt | while read -r MSG ; do
    	## CHANGEME: Remember to change the Slack incoming webhooks url, channel name and the bot user name 
        echo $MSG | python ./slackcmd/slackcmd.py -u https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX -c"#your-slack-channel-name-here" -n slack-bot-user-name-here
        sleep 1 # Slow down, just in case.
    done
fi

rm -f session.log
rm -f processed.txt
echo `date` ": found and processed" $CHAT_LINES "lines" >> tg2slack.log

