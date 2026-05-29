FactoryBot.define do
  factory :message do
    chat_room { nil }
    user { nil }
    content { "MyText" }
    deleted_at { "2026-05-10 21:22:49" }
  end
end
