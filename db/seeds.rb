# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# ユーザーを作成
puts 'Creating users...'
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password',
  password_confirmation: 'password'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password',
  password_confirmation: 'password'
)

user3 = User.create!(
  email: 'user3@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# 友達関係を作成
puts 'Creating friendships...'
Friendship.create!(user: user1, friend: user2, status: 'accepted')
Friendship.create!(user: user1, friend: user3, status: 'pending')

# user2 のイベントを作成
puts 'Creating events for user2...'
user2.events.create!(
  title: 'チームミーティング',
  start_time: Time.current + 1.day + 10.hours,
  end_time: Time.current + 1.day + 11.hours,
  body: '週次のチームミーティング'
)

user2.events.create!(
  title: 'ランチ',
  start_time: Time.current + 2.days + 12.hours,
  end_time: Time.current + 2.days + 13.hours,
  body: '友達とランチ'
)

user2.events.create!(
  title: 'プレゼン準備',
  start_time: Time.current + 3.days + 14.hours,
  end_time: Time.current + 3.days + 16.hours,
  body: 'プレゼン資料の作成'
)

user2.events.create!(
  title: '勉強会',
  start_time: Time.current + 5.days + 19.hours,
  end_time: Time.current + 5.days + 21.hours,
  body: 'Rails勉強会'
)

# user3 のイベントも作成（オプション）
puts 'Creating events for user3...'
user3.events.create!(
  title: 'コーディング',
  start_time: Time.current + 1.day + 15.hours,
  end_time: Time.current + 1.day + 17.hours,
  body: '個人開発'
)

puts 'Seed data created successfully!'
puts "Users: #{User.count}"
puts "Friendships: #{Friendship.count}"
puts "Events: #{Event.count}"