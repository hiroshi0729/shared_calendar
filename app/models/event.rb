class Event < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time
  
  private
  
  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?
    
    if end_time <= start_time
      errors.add(:end_time, 'は開始時刻より後に設定してください')
    end
  end
end
