class CreateChatRoomMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_room_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat_room, null: false, foreign_key: true
      t.datetime :last_read_at

      t.timestamps
    end
    
    add_index :chat_room_memberships, [:user_id, :chat_room_id], unique: true
  end
end
