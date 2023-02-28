# frozen_string_literal: true

class ChatSearchService < ApplicationService
  attr_reader :sender_id, :message_params, :chat_room_name

  def initialize(**args)
    @params = args
    @sender_id = @params[:sender_id]
    # @receiver_id = @params[:receiver_id]
    @message_params = @params[:message_params]
    @chat_room_name = @params[:chat_room_name]
  end

  def search
    # phone_numbers = [sender.phone_number.last(3), receiver.phone_number.last(3)].sort!
    chat_room = ChatRoom.find_by_name(chat_room_name)
    if chat_room.present?
      chat_room_participant1 = ChatRoomParticipant.find_by_user_and_chat_ids(sender_id, chat_room)
      message = chat_room_participant1.chat_room_messages.new(message_params)
      message.chat_room_id = chat_room
      [message, chat_room]
    end
  end
end
