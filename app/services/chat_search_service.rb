# frozen_string_literal: true

class ChatSearchService < ApplicationService
  attr_reader :sender, :receiver, :message_params

  def initialize(**args)
    @params = args
    @sender = @params[:sender]
    @receiver = @params[:receiver]
    @message_params = @params[:message_params]
  end

  def search
    phone_numbers = [sender.phone_number.last(3), receiver.phone_number.last(3)].sort!
    chat_room = ChatRoom.find_by_phone(phone_numbers.join('-'))
    if chat_room.present?
      chat_room_participant1 = ChatRoomParticipant.find_by_user_and_chat_ids(sender.id, chat_room)
    else
      chat_room, chat_room_participant1 = create_chat_and_participants(phone_numbers)
    end

    message = chat_room_participant1.chat_room_messages.new(message_params)
    message.chat_room_id = chat_room
    [message, chat_room]
  end

  def create_chat_and_participants(phone_numbers)
    chat_room = ChatRoom.create(name: phone_numbers.join('-'), user_id: sender.id)
    chat_room_participant1 = ChatRoomParticipant.create(user_id: sender.id, chat_room_id: chat_room.id,
                                                        receiver_name: receiver.name)
    chat_room_participant2 = ChatRoomParticipant.create(user_id: receiver.id, chat_room_id: chat_room.id,
                                                        receiver_name: sender.name)

    [chat_room.id, chat_room_participant1]
  end
end
