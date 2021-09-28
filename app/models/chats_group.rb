class ChatsGroup < ApplicationRecord
  belongs_to :chat
  belongs_to :group

  validates :chat, uniqueness: { scope: :group }
end
