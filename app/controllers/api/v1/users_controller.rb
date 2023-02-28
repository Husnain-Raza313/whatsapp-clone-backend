# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        authorize
        users = if params[:query].present?
                  User.search(params[:query],
                              { fields: ['name'],
                                match: :word_start }).where.not(id: @user_id)
                else
                  User.where.not(id: @user_id)
                end
        render json: users, status: :ok
      end

      def create
        @user = User.new(user_params)
        if @user.valid?
          # send_otp
          save_user
        else
          render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def verify_otp
        @user = User.new(user_params)
        @user.otp_secret_key = params[:otp_secret_key]
        if params[:id].present? && @user.authenticate_otp(params[:id], drift: 7.days.to_i)
          save_user
        else
          # PhoneNumberVerificationService.new(user: @user).send
          render json: { message: 'Please Try Again With Correct OTP' }
        end
      end

      private

      def user_params
        params.permit(:name, :phone_number, :username, :password, :password_confirmation, :password_digest, :profile_pic
                      ).select {|x,v| v.present?}
      end

      def save_user
        if @user.save
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token, exp: expiry_time }, status: :ok
        else
          render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def send_otp
        # result = PhoneNumberVerificationService.new(user: @user).send
        if result
          render json: { user: @user, otp_secret_key: @user.otp_secret_key }, status: :ok
        else
          render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
