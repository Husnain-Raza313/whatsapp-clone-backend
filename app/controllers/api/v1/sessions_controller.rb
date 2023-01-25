# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        @user = User.find_by(phone_number: params[:phone_number])
        if @user&.authenticate(params[:password])
          token = encode_token({ user_id: @user.id })
          time = Time.zone.now + 5.minutes.to_i
          render json: { user: @user, exp: time.strftime('%m-%d-%Y %H:%M'), token: token }, status: :ok
        else
          render json: { message: 'Invalid Credentials' }
        end
      end
    end
  end
end
