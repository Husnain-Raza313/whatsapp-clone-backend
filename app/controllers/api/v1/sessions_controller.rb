# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      # include HandleSessionExpiryConcern

      # def create
      #   render json: { message: 'Already Logged In' }, status: 422 and return if session[:session_token].present? && get_session_time_left

      #   user = User.find_by_phone_number(params[:phone_number])
      #   if user&.authenticate(params[:password])
      #     session[:session_token] = new_session_token
      #     render json: { user: user, session_token: session[:session_token], message: 'Success' }
      #   else
      #     render json: { message: 'Invalid Credentials' }
      #   end
      # end

      def create
        @user = User.find_by_phone_number(params[:phone_number])
        if @user&.authenticate(params[:password])
          token = encode_token({ user_id: @user.id})
          time = Time.now + 5.minutes.to_i
          render json: { user: @user, exp: time.strftime("%m-%d-%Y %H:%M"), token: token }, status: :ok
        else
          render json: { message: 'Invalid Credentials' }
        end
      end

      def destroy
        session[:session_token] = nil
        session[:login_time] = nil
        render json: { message: 'You have been logged out!!!' }
      end

      # private

      # def new_session_token
      #   session[:login_time] = Time.now
      #   SecureRandom.urlsafe_base64
      # end

    end
  end
end
