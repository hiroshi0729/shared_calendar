FactoryBot.define do
  factory :chat_room_membership do
    user { nil }
    chat_room { nil }
    last_read_at { "2026-05-10 21:21:25" }
  end
end
