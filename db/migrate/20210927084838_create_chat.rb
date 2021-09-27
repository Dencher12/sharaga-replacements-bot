class CreateChat < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.integer :chat_id
      t.timestamps
    end
  end
end
