# frozen_string_literal: true

module Api
  module V1
    class ChatRoomMessagesController < ApplicationController
      before_action :set_users, only: %i[show]
      before_action :authorize

      def index
        # chat_room_id = ChatRoom.find_by_name(params[:chat_room_name])
        chat_room_id = ChatRoom.where(name: params[:chat_room_name]).pluck(:id)[0]
        if chat_room_id.present?
          sender = ChatRoomParticipant.find_by_user_and_chat_ids(@user_id, chat_room_id)
          @chat_room_messages = ChatRoomMessage.find_messages(chat_room_id)
          render json: {messages: @chat_room_messages, sender: sender }
        else
          render json: { message: 'You have no conversation with this user' }
        end
      end

      def show
        chat_room_id, message = CreateChatService.new(sender: @user1, receiver: @user2,
          chat_room_name: params[:chat_room_name]).search_chat_room

        if chat_room_id.blank?
          render json: { message: message }, status: :unprocessable_entity
        else
          render json: {chat_room_id: chat_room_id }, status: :ok
        end
      end

      def create
        render json: { message: 'Invalid ChatRoom' }, status: :unprocessable_entity and return unless params[:chat_room_name]

        @message, @chat_room = ChatSearchService.new(sender_id: @user_id, chat_room_name: params[:chat_room_name],
                                                     message_params: message_params).search
        if @message.save
          ActionCable.server.broadcast "chat_room_#{@chat_room}", @message
          render json: @message.body
        else
          render json: { message: @message.errors.full_messages }, status: :unprocessable_entity
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
        if params[:chat_room_name].present?
          @user1 = User.find_by(id: @user_id)
          @user2 = User.find_by(id: params[:id])
        else
          render json: { message: 'Wrong ChatRoom' }
        end
      end
    end
  end
end
