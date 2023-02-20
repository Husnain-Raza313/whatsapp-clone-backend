# frozen_string_literal: true

class ChatRoomMessage < ApplicationRecord
  validates :body, presence: true

  belongs_to :chat_room_participant
  belongs_to :chat_room

end
