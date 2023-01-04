class ChatRoomParticipant < ApplicationRecord
  has_many :chat_room_messages, dependent: :destroy
  belongs_to :user
  belongs_to :chat_room
end
