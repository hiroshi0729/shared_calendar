class User < ApplicationRecord
  authenticates_with_sorcery!

  # アソシエーション
  has_many :events, dependent: :destroy
  
  # 自分が申請した友達関係
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend
  
  # 自分が承認された友達関係(逆方向)
  has_many :inverse_friendships, class_name: 'Friendship', 
           foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  
  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  
  # 承認済みの友達を取得するメソッド
  def accepted_friends
    # 自分が申請して承認された友達
    accepted_sent = friends.where(friendships: { status: 'accepted' })
    # 自分が承認した友達
    accepted_received = inverse_friends.where(friendships: { status: 'accepted' })
    
    (accepted_sent + accepted_received).uniq
  end
  
  # 友達申請を送る
  def send_friend_request(friend)
    friendships.create(friend: friend, status: 'pending')
  end
  
  # 友達申請を承認する
  def accept_friend_request(friend)
    friendship = inverse_friendships.find_by(user: friend, status: 'pending')
    friendship&.update(status: 'accepted')
  end
  
  # 友達関係を確認する
  def friend_with?(other_user)
    accepted_friends.include?(other_user)
  end

   # チャット関連のアソシエーション
   has_many :chat_room_memberships, dependent: :destroy
   has_many :chat_rooms, through: :chat_room_memberships
   has_many :messages, dependent: :destroy
end
