class EventGuest < ApplicationRecord
  belongs_to :event
  belongs_to :user
  
  # 同じユーザーが同じイベントに重複してゲスト登録されないようにする
  validates :user_id, uniqueness: { scope: :event_id, message: 'は既にこのイベントのゲストとして登録されています' }
  
  # イベントの主催者が自分自身をゲストとして追加できないようにする(オプション)
  validate :cannot_add_owner_as_guest
  
  private
  
  def cannot_add_owner_as_guest
    if event && event.user_id == user_id
      errors.add(:user_id, 'イベントの主催者は自分自身をゲストとして追加できません')
    end
  end
end