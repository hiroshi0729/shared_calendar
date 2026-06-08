class Message < ApplicationRecord
  # アソシエーション
  belongs_to :chat_room
  belongs_to :user
  
  # Active Storage による画像添付
  has_one_attached :image
  
  # バリデーション
  # メッセージ本文か画像のどちらかは必須
  validates :content, presence: true, unless: -> { image.attached? }
  
  # 画像のバリデーション
  validate :acceptable_image, if: -> { image.attached? }
  
  # スコープ
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  # 🆕 未読・既読関連のスコープを追加
  scope :unread, -> { where(read: false) }
  scope :read_messages, -> { where(read: true) }
  
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
    return '(削除されたメッセージ)' if deleted?
    return content if content.present?
    '(画像)' if image.attached?
  end
  
  # 🆕 既読にする
  def mark_as_read!
    update(read: true)
  end
  
  # 🆕 未読かどうか
  def unread?
    !read
  end
  
  private
  
  # 画像の形式とサイズをチェック
  def acceptable_image
    return unless image.attached?
    
    # ファイルサイズチェック（5MB以下）
    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, 'のサイズは5MB以下にしてください')
    end
    
    # ファイル形式チェック
    acceptable_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, 'はJPEG、PNG、GIF形式のみアップロード可能です')
    end
  end
end