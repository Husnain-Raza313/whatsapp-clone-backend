# frozen_string_literal: true

class CreateChatService < ApplicationService
  attr_reader :sender, :receiver, :chat_room_name

  def initialize(**args)
    @params = args
    @sender = @params[:sender]
    @receiver = @params[:receiver]
    @chat_room_name = @params[:chat_room_name]
  end

  def search_chat_room
    chat_room_id = ChatRoom.where(name: chat_room_name).pluck(:id)[0]
    # chat_room_id = ChatRoom.find_by_name(chat_room_name)
    if chat_room_id.blank?
      create_chat_and_participants
    else
      [chat_room_id, message = nil]
    end

  end

  def create_chat_and_participants
    chat_room = ChatRoom.new(name: chat_room_name, user_id: sender.id)
    if chat_room.save
      chat_room_participant1 = ChatRoomParticipant.create(user_id: sender.id, chat_room_id: chat_room.id,
                                                        receiver_name: receiver.name)
      chat_room_participant2 = ChatRoomParticipant.create(user_id: receiver.id, chat_room_id: chat_room.id,
                                                        receiver_name: sender.name)

      [chat_room.id, message = nil]
    else
      [chat_room.id = nil, message = chat_room.errors.full_messages ]
    end

  end
end
