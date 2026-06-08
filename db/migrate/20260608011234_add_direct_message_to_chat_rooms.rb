class AddDirectMessageToChatRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :chat_rooms, :direct_message, :boolean, default: false, null: false
  end
end
