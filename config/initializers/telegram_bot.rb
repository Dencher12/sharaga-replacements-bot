require 'telegram/bot'

TELEGRAM_BOT = Telegram::Bot::Client.new(Rails.application.credentials.telegram[:token])
