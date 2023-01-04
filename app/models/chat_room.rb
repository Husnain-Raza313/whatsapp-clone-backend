class ChatRoom < ApplicationRecord
  validates :name, presence: true

  has_many :chat_room_participants, dependent: :destroy
  has_many :chat_room_messages, dependent: :destroy
end
