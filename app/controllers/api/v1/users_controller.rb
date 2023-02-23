# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      # before_action :set_user, only: [:verify_otp]

      def index
        authorize
        users = params[:query].present? ? User.search(params[:query],{fields: ['name'], match: :word_start}) : User.where.not(id: @user.id)
        # users = User.where.not(id: @user.id)
        render json: users, status: :ok
      end
      def create
        @user = User.new(user_params)
        # set_profile_pic
        # if @user.valid?
        #   send_otp
        # else
        #   render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
        # end
        if @user.save
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token, exp: expiry_time }, status: :ok
        else
          render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
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
        # if @user.save
        #   token = encode_token({ user_id: @user.id })
        #   render json: { user: @user, token: token, exp: expiry_time }, status: :ok
        # else
        #   render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
        # end
        # if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
        #   render json: { message: 'Success' }, status: :ok
        # else
        #   # PhoneNumberVerificationService.new(user: @user).send
        #   render json: { message: 'Please Try Again With Correct OTP' }
        # end
        #   @user = User.new(user_params)
        #   if @user.save
        #   token = encode_token({ user_id: @user.id })
        #   render json: { user: @user, token: token, exp: expiry_time }, status: :ok
        # else
        #   render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
        # end
      end

      private

      def user_params
        params.permit(:name, :phone_number, :username, :password, :password_confirmation, :password_digest, :profile_pic)
        # params.require(:user).permit!
      end

      def set_user
        @user = User.find_by(id: params[:id])
      end

      # def set_profile_pic
      #   return unless params[:user][:image]
      #   byebug
      #   @user.profile_pic.attach(params[:user][:image])
      #   @user.image = url_for(@user.profile_pic)
      # end

      def save_user
        if @user.save
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token, exp: expiry_time }, status: :ok
        else
          render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def send_otp
        result = PhoneNumberVerificationService.new(user: @user).send
          # render json: { user: @user}, status: :ok if result
          # render json: result ? { user: @user}, status: :ok : { message: @user.errors.full_messages}, status: :unprocessable_entity
          if result
            render json: { user: @user, otp_secret_key: @user.otp_secret_key}, status: :ok
          else
            render json: { message: @user.errors.full_messages}, status: :unprocessable_entity
          end
      end
    end
  end
end
