module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by_phone_number(params[:phone_number])
        if user && user.authenticate(params[:password])
          session[:session_token] = new_session_token
          render json: { user: user, session_token: session[:session_token], message: 'Success' }
        else
          render json: 'Invalid Credentials'
        end
      end

      def destroy
        session[:session_token] = nil
        render json: 'You have been logout'
      end

      private

      def new_session_token
        SecureRandom.urlsafe_base64
      end

    end
  end
end
