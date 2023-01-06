module Api
  module V1
    class ChatRoomMessagesController < ApplicationController
      before_action :set_users, only: [:create]

      def index
        @chat_room_messages = ChatRoomMessages.where(chat_room_id: params[:chat_room_id]).order("created_at DESC") if params[:chat_room_id].present?
        if @chat_room_messages.present?
          render json: @chat_room_messages
        else
          render json: 'You have no conversation with this user'
        end
      end

      def create
        @message, @chat_room = ChatSearchService.new(user1: @user1, user2: @user2, message_params: message_params)
        if @message.save
          ChatRoomChannel.broadcast_to(@message, @chat_room)
          render json: @message
        else
          render json: @message.errors.full_messages, status: 422
        end

      end

      private

      def message_params
        params.require(:chat_room_message).permit(:body)
      end

      def set_users
        byebug
        if params[:user_id].present? && params[:phone_number].present?
          @user1 = User.find_by(id: params[:user_id])
          @user2 = User.find_by(phone_number: params[:phone_number])
        else
          render json: 'Please enter a valid phone number'
        end
      end
    end
  end
end
