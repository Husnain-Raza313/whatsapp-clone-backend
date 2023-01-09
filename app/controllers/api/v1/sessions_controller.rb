# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      include HandleSessionExpiryConcern

      def create
        render json: { message: 'Already Logged In' }, status: 422 and return if session[:session_token].present? && get_session_time_left

        user = User.find_by_phone_number(params[:phone_number])
        if user&.authenticate(params[:password])
          session[:session_token] = new_session_token
          render json: { user: user, session_token: session[:session_token], message: 'Success' }
        else
          render json: { message: 'Invalid Credentials' }
        end
      end

      def destroy
        session[:session_token] = nil
        render json: { message: 'You have been logged out!!!' }
      end

      private

      def new_session_token
        session[:expires_at] = Time.now
        SecureRandom.urlsafe_base64
      end

    end
  end
end
