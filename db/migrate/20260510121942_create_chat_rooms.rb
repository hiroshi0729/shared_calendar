class CreateChatRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_rooms do |t|
      t.integer :room_type, null: false, default: 0
      t.string :name

      t.timestamps
    end
    
    add_index :chat_rooms, :room_type
  end
end
