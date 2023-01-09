module Api
  module V1
    class ChatRoomParticipantsController < ApplicationController
      def show
        user = User.find_by(id: params[:id])
        receivers = user.chat_room_participants.pluck(:receiver_name)
        render json: receivers
      end
    end
  end
end
