class Message < ApplicationRecord
  # アソシエーション
  belongs_to :chat_room
  belongs_to :user
  
  # バリデーション
  validates :content, presence: true
  
  # スコープ
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  # 削除されているか
  def deleted?
    deleted_at.present?
  end
  
  # 論理削除
  def soft_delete!
    update(deleted_at: Time.current)
  end
  
  # 表示用のコンテンツ
  def display_content
    deleted? ? '(削除されたメッセージ)' : content
  end
end
