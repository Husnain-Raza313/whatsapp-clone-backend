# frozen_string_literal: true

class ChatRoomParticipant < ApplicationRecord
  has_many :chat_room_messages, dependent: :destroy
  belongs_to :user
  belongs_to :chat_room

  scope :find_by_user_and_chat_ids, lambda { |sender_id, chat_room_id|
                                      where(user_id: sender_id, chat_room_id: chat_room_id).pluck(:id)[0]
                                    }
  scope :receiver_names, -> { pluck(:receiver_name) }
end
