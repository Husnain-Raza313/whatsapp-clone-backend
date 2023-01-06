class ChatSearchService < ApplicationService
  attr_reader :user1, :user2, :message_params

  def initialize(**args)
    @user1 = args[:user1]
    @user2 = args[:user2]
    @message_params = args[:message_params]
    byebug
  end

  def search
    phone_numbers = [user1.phone_number, user2.phone_number].sort!
    chat_room = ChatRoom.find_by(name: phone_numbers.join('-'))
    chat_room_particpant1 = ChatRoomParticipant.create(user_id: user1.id, chat_room_id: chat_room.id) if chat_room.present?
    chat_room, chat_room_particpant1 = create_chat_and_participants unless chat_room.present?
    message = chat_room_particpant1.chat_room_messages.new(message_params)
    message.chat_room_id = chat_room.id
    [message, chat_room]
  end

  def create_chat_and_participants
    chat_room = ChatRoom.create(name:  phone_numbers.join('-'))
    chat_room_particpant1 = ChatRoomParticipant.create(user_id: user1.id, chat_room_id: chat_room.id)
    chat_room_particpant2 = ChatRoomParticipant.create(user_id: user2.id, chat_room_id: chat_room.id)

    [chat_room, chat_room_particpant1]
  end
end
