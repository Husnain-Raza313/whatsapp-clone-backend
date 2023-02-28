# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        @user = User.find_by(phone_number: params[:phone_number])
        if @user&.authenticate(params[:password])
          token = encode_token({ user_id: @user.id })
          render json: { user: @user , exp: expiry_time, token: token, profile_pic: profile_pic }, status: :ok
        else
          render json: { message: 'Invalid Credentials' }, status: :unprocessable_entity
        end
      end

      private

      def profile_pic
        rails_blob_path(@user.profile_pic, only_path: true) if @user.profile_pic.attached?
      end
    end
  end
end
