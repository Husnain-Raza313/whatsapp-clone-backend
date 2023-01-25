# frozen_string_literal: true

class AddReceiverNameInChatRoomParticipantTable < ActiveRecord::Migration[6.1]
  def change
    add_column :chat_room_participants, :receiver_name, :string, null: false
  end
end
