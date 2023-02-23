# frozen_string_literal: true

class ChatRoomMessage < ApplicationRecord
  validates :body, presence: true

  belongs_to :chat_room_participant
  belongs_to :chat_room

  scope :find_messages, ->(chat_room_id) { where(chat_room_id: chat_room_id).order('created_at ASC') }
end
