class CreateChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms do |t|
      t.string :name, null: false, default: ''
      t.timestamps
    end
  end
end
