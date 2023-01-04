class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ''
      t.string :username, null: false, default: ''
      t.string :phone_number, null: false, default: ''
      t.string :password, null: false, default: ''
      t.string :otp_secret_key
      t.string :session_token, null: false, default: ''
      t.timestamps
    end
    add_index :users, :phone_number, unique: true
    add_index :users, :session_token, unique: true
  end
end
