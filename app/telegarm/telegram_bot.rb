require File.expand_path('../../config/environment', __dir__)
require 'telegram/bot'
require 'async'
require_relative 'replacements_parser'

def fetch_replacements(message)
  group = Group.find_by_name message.text.split(' ')[1]
  if group.nil?
    TELEGRAM_BOT.api.send_message(chat_id: message.chat.id, text: 'Нет такой группы')
  else
    reps = ReplacementsParser.parse_to_string(group.page_url)
    TELEGRAM_BOT.api.send_message(chat_id: message.chat.id, text: reps)
  end
end

def subscribe(message)
  groups = message.text.split(' ')[1..]
  groups.each do |g|
    chat = Chat.find_or_create_by(chat_id: message.chat.id)
    group = Group.find_by_name(g)
    if group.nil?
      TELEGRAM_BOT.api.send_message(chat_id: chat.chat_id, text: 'Нет такой группы')
    else
      begin
        group.chats << chat
        TELEGRAM_BOT.api.send_message(chat_id: chat.chat_id, text: "Подписка на #{group.name} подтверждена!")
      rescue ActiveRecord::RecordInvalid
        TELEGRAM_BOT.api.send_message(chat_id: chat.chat_id, text: "Вы уже подписаны на #{group.name}!")
      end
    end
  end
end

TELEGRAM_BOT.run do
  TELEGRAM_BOT.listen do |message|
    if message.text.start_with?('/r')
      fetch_replacements(message)
    elsif message.text.start_with?('/s')
      subscribe(message)
    end
  end
end
