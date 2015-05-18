# telegram-slack-bridge

This is a quick-and-dirty Telegram to Slack bridge using off-the-shelf tools. We use vysheng's command line telegram client (https://github.com/vysheng/tg) and pzelnip's command line Slack tool (https://github.com/pzelnip/slackcmd).  Read the readme's of these projects if you want to know how they work, but it is not necessary for our purpose.

## Instructions to use

### Get the code

On a linux server, make sure you have the necessary packages to run gcc, make, python and expect. Then,  

```text
mkdir tg2slack
cd tg2slack
git clone https://github.com/pzelnip/slackcmd.git
git clone https://github.com/vysheng/tg.git
git clone https://github.com/soorajmr/telegram-slack-bridge.git # This repo
```

You need to build the telegram client by running ./configure and make inside the tg directory. Refer to the github page of that project if you need more details.  

### TG Key and Slack webhook URL 

Now, before running the telegram client, you need the public key for your account. Log on to https://my.telegram.org using your phone number and in the App Configuration section you get the RSA public key. Copy paste the text of the key into a file named tg_server.pub and place this file in the tg2slack directory we created above.  

Now, we do a test run of the telegram client for it to mark the messages so far as read. You will be placed in an interactive command line shell. You can use various commands to see the history of commands posted so far etc. type "help" to see the options. It is a good idea to check the history of the channel you are going to bridge, to make sure the client has read the messages so far.

```text
tg/bin/telegram-cli -k tg_server.pub
```

Now exit the telegram client.  

Go to Slack admin page and add an "incoming webhooks" integration. Note down the url and the bot name. While adding the integration, you need to specify the channel where you want the bridge to post to (more details at https://github.com/pzelnip/slackcmd).

### Make changes in the scripts

You need to make some changes in the two scripts tg2slack.sh and get_chat.expect inside the telegram-slack-bridge directory. Please look for "CHANGEME" tags in both the scripts and the comments should explain what to change.

After you set the paths, patterns etc. in the scirpts, you are ready to go. Make sure tg2slack.sh has execute permission. Then you may just run the script telegram-slack-bridge/tg2slack.sh or you could add a cron job as below (this invokes the script every 5 min):

Run this:

```text
crontab -e
```
In the editor window, add a new line as below, with the path modified appropriately:

```text
*/5 * * * * /some/path/tg2slack/telegram-slack-bridge/tg2slack.sh
```






