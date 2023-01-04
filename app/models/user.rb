class User < ApplicationRecord
  validates :username, :name, :phone_number, :password, presence: true
  validates :phone_number, uniqueness: true

  has_many :chat_room_participants, dependent: :destroy
end
