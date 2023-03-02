# frozen_string_literal: true

class PhoneNumberVerificationService < ApplicationService
  include ActiveModel::Validations
  attr_reader :user, :client, :params

  def initialize(**args)
    @params = args
    @user = @params[:user]
    @client = Twilio::REST::Client.new
  end

  def send
    client.messages.create(
      from: twilio_phone_number.to_s,
      to: user[:phone_number].to_s,
      body: "Please Enter This code: #{user.otp_code}"
    )
    true
  rescue Twilio::REST::RestError => e
    params[:user].errors.add(:base, 'please Enter a valid phone number')
    false
  end

  private

  def twilio_phone_number
    Rails.application.credentials.twilio[:phone_number]
  end
end
