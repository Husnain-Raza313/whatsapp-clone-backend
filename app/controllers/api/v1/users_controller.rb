# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:verify_otp]
      def create
        @user = User.new(user_params)
        result = PhoneNumberVerificationService.new(user: @user).send
        if result && @user.save
          render json: @user, status: :ok
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      def verify_otp
        if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
          render json: 'Success', status: 200
        else
          PhoneNumberVerificationService.new(user: @user).send
          render json: 'Please try again with new otp'
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone_number, :username, :password, :password_confirmation)
      end

      def set_user
        @user = User.find_by(id: params[:id])
      end
    end
  end
end
