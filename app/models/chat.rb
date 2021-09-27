class Chat < ApplicationRecord
  has_many :chats_groups
  has_many :groups, through: :chats_groups
end
