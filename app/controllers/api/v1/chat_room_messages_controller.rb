# frozen_string_literal: true

module Api
  module V1
    class ChatRoomMessagesController < ApplicationController
      before_action :set_users, only: %i[create index show]
      before_action :authorize

      def index
        # chat_room_id = ChatRoom.find_by_phone(phone_numbers.join('-'))
        chat_room_id = ChatRoom.where(name: chat_room_name).pluck(:id)[0]
        if chat_room_id.present?
          sender = ChatRoomParticipant.find_by_user_and_chat_ids(@user1.id, chat_room_id)
          @chat_room_messages = ChatRoomMessage.find_messages(chat_room_id)
          render json: {messages: @chat_room_messages, sender: sender }
        else
          render json: { message: 'You have no conversation with this user' }
        end
      end

      def show
        byebug
        # chat_room_id = ChatRoom.where(name: phone_numbers).pluck(:id)[0]
        chat_room_id, message = CreateChatService.new(sender: @user1, receiver: @user2,
          chat_room_name: chat_room_name).search_chat_room

        if chat_room_id.blank?
          render json: { message: message }, status: :unprocessable_entity
        else
          render json: {chat_room_id: chat_room_id }, status: :ok
        end
      #   if chat_room_id.blank?
      #     CreateChatService.new(sender: @user1, receiver: @user2,
      #       phone_numbers: phone_numbers).create_chat_and_participants
      #     @chat_room = ChatRoom.new(name: phone_numbers.join('-'), user_id: @user1.id)
      #   if @chat_room.save
      #     chat_room_participant1 = ChatRoomParticipant.create(user_id: @user1.id, chat_room_id: @chat_room.id,
      #                                                       receiver_name: @user2.name)
      #     chat_room_participant2 = ChatRoomParticipant.create(user_id: @user2.id, chat_room_id: @chat_room.id,
      #                                                       receiver_name: @user1.name)

      #     render json: {chat_room_id: @chat_room.id }
      #   else
      #     render json: { message: @chat_room.errors.full_messages }, status: :unprocessable_entity
      #   end
      # else
      #   render json: {chat_room_id: chat_room }
      # end

      end

      def create
        render json: { message: 'Invalid User' }, status: :unprocessable_entity and return unless @user1 && @user2

        @message, @chat_room = ChatSearchService.new(sender: @user1, receiver: @user2,
                                                     message_params: message_params).search
        if @message.save
          ActionCable.server.broadcast "chat_room_#{@chat_room}", @message
          render json: @message.body
        else
          render json: @message.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.permit(:body)
      end

      def chat_room_name
        phone_numbers = [@user1.phone_number.last(3), @user2.phone_number.last(3)].sort!
        phone_numbers = phone_numbers.join('-')
      end

      def set_users
        authorize
        if params[:phone_number].present?
          @user1 = @user
          @user2 = User.find_by(phone_number: get_phone_number)
        else
          render json: { message: 'Please Enter a Valid Phone Number' }
        end
      end
    end
  end
end
