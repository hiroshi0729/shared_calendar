class ChatRoomMembership < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :chat_room
  
  # 未読メッセージ数を取得
  def unread_count
    return 0 if last_read_at.nil?
    
    chat_room.messages
             .where('created_at > ?', last_read_at)
             .where.not(user_id: user_id)
             .count
  end
  
  # 既読にする
  def mark_as_read!
    update(last_read_at: Time.current)
  end
end
