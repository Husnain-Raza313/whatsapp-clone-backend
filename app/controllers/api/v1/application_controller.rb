# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      def encode_token(payload, exp = 25.minutes.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, 'secret')
      end

      def decode_token
        auth_header = request.headers['Authorization']
        return unless auth_header

        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, 'secret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end

      def authorized_user
        decoded_token = decode_token
        return unless decoded_token

        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end

      def authorize
        render json: { message: 'You Have To Log in first' }, status: :unauthorized unless authorized_user
      end

      def expiry_time
        time = Time.zone.now + 25.minutes.to_i
        time.strftime('%m-%d-%Y %H:%M')
      end

      def get_phone_number
        phone_no = params[:body].present? ? params[:phone_number] : "+#{params[:phone_number]}"
        phone_no.delete(" ")
      end
    end
  end
end
