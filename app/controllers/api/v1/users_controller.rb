# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:verify_otp]
      def create
        @user = User.new(user_params)
        # set_profile_pic
        # result = PhoneNumberVerificationService.new(user: @user).send
        # if result && @user.save
        if @user.save
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }, status: :ok
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      def verify_otp
        if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
          render json: { message: 'Success' }, status: :ok
        else
          PhoneNumberVerificationService.new(user: @user).send
          render json: { message: 'Please Try Again With New OTP' }
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone_number, :username, :password, :password_confirmation)
      end

      def set_user
        @user = User.find_by(id: params[:id])
      end

      def set_profile_pic
        return unless params[:file]

        @user.profile_pic.attach(params[:file])
        @user.image = url_for(@user.profile_pic)
      end
    end
  end
end
