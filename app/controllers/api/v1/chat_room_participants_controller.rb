module Api
  module V1
    class ChatRoomParticipantsController < ApplicationController
      before_action :check_session_token
      before_action :session_expiry

      include HandleSessionExpiryConcern

      def show
        user = User.find_by(id: params[:id])
        receivers = user.chat_room_participants.receiver_names
        render json: receivers
      end
    end
  end
end
