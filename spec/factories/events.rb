FactoryBot.define do
  factory :event do
    title { "MyString" }
    description { "MyText" }
    start_time { "2026-05-07 10:45:53" }
    end_time { "2026-05-07 10:45:53" }
    user { nil }
  end
end
