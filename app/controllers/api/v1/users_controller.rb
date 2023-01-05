module Api
  module V1
    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        result = PhoneNumberVerificationService.new(user: @user).send
        if result && @user.save
          render json: @user, status: 200
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone_number, :username)
      end
    end
  end
end
