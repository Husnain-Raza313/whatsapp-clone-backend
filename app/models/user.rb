# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, :name, :phone_number, :password, presence: true
  validates :phone_number, uniqueness: true
  validates :username, uniqueness: true
  validates :phone_number, numericality: true, length: { minimum: 11, maximum: 15 }
  validates :profile_pic, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  has_secure_password
  has_one_time_password column_name: :otp_secret_key, length: 6
  has_one_attached :profile_pic
  has_many :chat_room_participants, dependent: :destroy
  has_many :chat_rooms, dependent: :destroy

  scope :find_by_phone_number, ->(phone_number) { find_by(phone_number: phone_number) }

  searchkick word_start: [:name]

  def search_data
    { name: name }
  end

end
