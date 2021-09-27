class CreateChatGroup < ActiveRecord::Migration[6.1]
  def change
    create_table :chats_groups do |t|
      t.integer :chat_id
      t.integer :group_id
    end
  end
end
