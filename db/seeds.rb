# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# テスト用ユーザーを作成
users_data = [
  {
    email: 'test01@gmail.com',
    password: 'password',
    password_confirmation: 'password',
    last_name: 'テスト',
    first_name: '太郎'
  },
  {
    email: 'test02@gmail.com',
    password: 'password',
    password_confirmation: 'password',
    last_name: 'テスト',
    first_name: '花子'
  }
]

users = []
users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password_confirmation]
    u.last_name = user_data[:last_name]
    u.first_name = user_data[:first_name]
  end
  users << user
end

# 個人チャットルームを作成
if users.size >= 2
  chat_room = ChatRoom.find_or_create_by!(direct_message: true, name: nil) do |room|
    # 特に設定なし
  end

  users.each do |user|
    ChatRoomUser.find_or_create_by!(chat_room: chat_room, user: user)
  end

  puts "テスト用ユーザーと個人チャットルームを作成しました"
end