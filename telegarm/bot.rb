require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
require_relative 'replacements_parser'

token = Rails.application.credentials.telegram[:token]

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if message.text.start_with?('/r')
      group = Group.find_by_name message.text.split(' ')[1]
      if group.nil?
        bot.api.send_message(chat_id: message.chat.id, text: 'Нет такой группы')
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'В процессе ...')
        reps = ReplacementsParser.parse_to_string(group.page_url)
        bot.api.send_message(chat_id: message.chat.id, text: reps)
      end
    end
  end
end
