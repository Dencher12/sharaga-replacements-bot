class Group < ApplicationRecord
  has_many :chats_groups
  has_many :chats, through: :chats_groups
end
