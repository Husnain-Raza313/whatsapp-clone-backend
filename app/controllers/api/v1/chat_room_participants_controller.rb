# frozen_string_literal: true

module Api
  module V1
    class ChatRoomParticipantsController < ApplicationController
      before_action :authorize

      def show
        user = User.find_by(id: params[:id])
        receivers = user.chat_room_participants.receiver_names
        render json: receivers
      end

      def destroy
        chatroom = ChatRoom.find_by(id: params[:id])
        if chatroom.destroy
          render json: { chatroom: chatroom, message: 'Success' }
        else
          render json: { message: chatroom.errors.full_messages }
        end
      end
    end
  end
end
