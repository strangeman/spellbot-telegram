# Description

Simple Telegram bot for sending site fragments to chat when users clicks Ctrl+Enter (e.g. when found a typo)

# Files

* bot.rb - bot code, uses telegram-bot-ruby and sinatra gems
* ctrlEnter.js - site JS code, send selected fragment to bot url, uses jQuery

# ENV variables

* spellbot_token - Telegram bot token
* spellbot_chat_id - chat id where we should send fragments
* spellbot_domain - allowed domain for fragment sending (spam prevention)

# Bot commands

* /start - did nothing, just confirm that bot is works
* /info - returns your chat_id
* /help - returns commands explanation

# How to install

* Register your bot and get token - https://core.telegram.org/bots
* Launch bot.rb on your favorite server with your favorite software (I prefer Heroku)
* Get your chat_id with /info command
* Add ctrlEnter.js to your site (do not forget change https://yourbot.com to your bot URL)