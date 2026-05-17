class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # ステータスの定義
  enum status: { pending: 0, accepted: 1, rejected: 2 }

  # バリデーション
  validates :user_id, uniqueness: { scope: :friend_id }
  validate :cannot_befriend_self

  private

  def cannot_befriend_self
    errors.add(:friend_id, 'cannot be the same as user_id') if user_id == friend_id
  end
end
