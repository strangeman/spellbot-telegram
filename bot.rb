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
            help_text = 'Bot commands'\
                        '* /start - did nothing, just confirm that bot is works'\
                        '* /info - returns your chat_id'\
                        '* /help - returns commands explanation'\
                        'Github: https://github.com/strangeman/spellbot-telegram'
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
