class User < ApplicationRecord
  has_one_attached :avatar
  authenticates_with_sorcery!

  # プロフィール画像の設定
  has_one_attached :avatar

  # アソシエーション
  has_many :events, dependent: :destroy

  # ゲストとして招待されているイベント
  has_many :event_guests, dependent: :destroy
  has_many :guest_events, through: :event_guests, source: :event
  
  # 自分が申請した友達関係
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend
  
  # 自分が承認された友達関係(逆方向)
  has_many :inverse_friendships, class_name: 'Friendship', 
           foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  
  # チャット関連のアソシエーション
  has_many :chat_room_memberships, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_memberships
  has_many :messages, dependent: :destroy
  
  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  
  # プロフィール画像のバリデーション
  validates :avatar, content_type: { in: ['image/png', 'image/jpeg'],
                                     message: 'はPNG、JPG、JPEG形式のみ対応しています' },
                     size: { less_than: 5.megabytes,
                            message: 'は5MB以下にしてください' }
  
  # 承認済みの友達を取得するメソッド
  def accepted_friends
    # 自分が申請して承認された友達
    sent_friends = User.joins(:inverse_friendships)
                      .where(friendships: { user_id: id, status: 'accepted' })
    
    # 自分が承認した友達
    received_friends = User.joins(:friendships)
                          .where(friendships: { friend_id: id, status: 'accepted' })
    
    # 重複を除いて結合（ActiveRecord::Relation を返す）
    User.where(id: sent_friends.pluck(:id) + received_friends.pluck(:id)).distinct
  end
  
  # 友達申請を送る
  def send_friend_request(friend)
    friendships.create!(friend: friend, status: 'pending')
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

  # アイコン画像のURLを返すメソッド
  def avatar_url
    if avatar.attached?
      # Active Storageで画像が添付されている場合
      Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true)
    else
      # UI Avatarsを使ってデフォルトアイコンを生成
      display_name = name.presence || email.split('@').first
      "https://ui-avatars.com/api/?name=#{CGI.escape(display_name)}&background=random&size=200"
    end
  end

  # 指定したユーザーと友達かどうかをチェック
  def friends_with?(other_user)
    accepted_friends.include?(other_user)
  end
end