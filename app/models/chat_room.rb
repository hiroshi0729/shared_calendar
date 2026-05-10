class ChatRoom < ApplicationRecord
    # アソシエーション
    has_many :chat_room_memberships, dependent: :destroy
    has_many :users, through: :chat_room_memberships
    has_many :messages, dependent: :destroy
    
    # enum の定義を位置引数形式に変更
    enum :room_type, { direct_message: 0, group: 1 }
    
    # バリデーション
    validates :room_type, presence: true
    validates :name, presence: true, if: :group?
    
    # 最新のメッセージを取得
    def latest_message
      messages.order(created_at: :desc).first
    end
  end
