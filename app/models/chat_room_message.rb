class ChatRoomMessage < ApplicationRecord
  belongs_to :chat_room_participant
  belongs_to :chat_room
end
