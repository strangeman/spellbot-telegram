#
# SpellBot-Telegram
#
# Copyright 2016, Anton Markelov
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'telegram/bot'
require 'sinatra'

spellbot_token = ENV['spellbot_token'] # Telegram bot token
spellbot_chat_id = ENV['spellbot_chat_id'] # Chat ID where bot will send notifications
spellbot_domain = ENV['spellbot_domain'] # Allowed domain for notifications

class SpellBot
  @bot = ''

  def initialize(token, chat_id)
    Thread.new do
      Telegram::Bot::Client.run(token) do |b|
        @bot = b
        @bot.listen do |message|
          case message.text
          when '/start'
            if message.chat.id == chat_id
              @bot.api.sendMessage(chat_id: chat_id, text: 'I\'m ready to serve you, my Lord!')
            else
              @bot.api.sendMessage(chat_id: message.chat.id, text: 'Sorry, I belong only to my Lord')
            end
          when '/info'
            @bot.api.sendMessage(chat_id: message.chat.id, text: "Sir, your chat_id is #{message.chat.id}")
          when '/help'
            help_text = "Bot commands: \n"\
                        "* /start - did nothing, just confirm that bot is works\n"\
                        "* /info - returns your chat_id\n"\
                        "* /help - returns commands explanation\n"\
                        "Github: https://github.com/strangeman/spellbot-telegram\n"
            @bot.api.sendMessage(chat_id: message.chat.id, text: help_text)
          end
        end
      end
    end
  end

  def send(message, id = spellbot_chat_id)
    @bot.api.sendMessage(chat_id: id, text: message)
  end
end

spell = SpellBot.new(spellbot_token, spellbot_chat_id)

options '/*' do
  headers['Access-Control-Allow-Origin'] = '*' << spellbot_domain
  headers['Access-Control-Allow-Methods'] = 'POST'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

get '/*' do
  redirect 'https://github.com/strangeman/spellbot-telegram'
end

post '/spell' do
  request.body.rewind # in case someone already read it
  data = request.body.read
  if data.include?(spellbot_domain)
    spell.send("Dear Sir, here is mistype: \n#{data}", spellbot_chat_id)
  end
  ''
end
