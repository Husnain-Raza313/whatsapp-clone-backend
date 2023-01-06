# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ''
      t.string :username, null: false, default: ''
      t.string :phone_number, null: false, limit: 15
      t.string 'password_digest'
      t.string :otp_secret_key
      t.timestamps
    end
    add_index :users, :phone_number, unique: true
  end
end
