class CreateChatRoomParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_room_participants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat_room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
