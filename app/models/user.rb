# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, :name, :phone_number, :password, presence: true
  validates :phone_number, uniqueness: true
  validates :phone_number, numericality: true, length: { minimum: 11, maximum: 15 }

  has_secure_password
  has_one_time_password column_name: :otp_secret_key, length: 6
  has_many :chat_room_participants, dependent: :destroy
  has_many :chat_rooms, dependent: :destroy

  after_initialize :generate_otp_secret_key, if: :new_record?

  scope :find_by_phone_number, ->(phone_number) { find_by(phone_number: phone_number) }

  def generate_otp_secret_key
    self.otp_secret_key = User.otp_random_secret
  end
end
