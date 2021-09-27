class ChatsGroup < ApplicationRecord
  belongs_to :chat
  belongs_to :group
end
