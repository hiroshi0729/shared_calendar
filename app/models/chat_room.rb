class ChatRoom < ApplicationRecord
  # アソシエーション
  has_many :chat_room_memberships, dependent: :destroy
  has_many :users, through: :chat_room_memberships
  has_many :messages, dependent: :destroy
  
  # enum の定義（接頭辞を付けて競合を回避）
  enum room_type: { direct_message: 0, group_chat: 1 }
  
  # バリデーション
  validates :room_type, presence: true
  validates :name, presence: true, if: :group_chat?
  
  # 個人チャットの相手を取得
  def partner(current_user)
    users.where.not(id: current_user.id).first
  end
  
  # チャット名を取得（個人チャットは相手の名前、グループチャットはグループ名）
  def display_name(current_user)
    if direct_message?
      partner(current_user)&.name || "不明なユーザー"
    else
      name
    end
  end
  
  # 最新のメッセージを取得
  def latest_message
    messages.order(created_at: :desc).first
  end
end
