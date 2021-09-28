require File.expand_path('../../config/environment', __dir__)
require 'sidekiq-scheduler'

class RepsBroadcastWorker
  include Sidekiq::Worker
  def perform
    chats = Chat.all
    chats.each do |chat|
      groups = chat.groups
      groups.each do |group|
        reps = ReplacementsParser.parse_to_string(group.page_url)
        reps = "~~~~~ #{group.name} ~~~~~\n" + reps
        TELEGRAM_BOT.api.send_message(chat_id: chat.chat_id, text: reps)
      end
    end
  end
end
