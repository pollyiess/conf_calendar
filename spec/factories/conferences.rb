FactoryBot.define do
  factory :conference do
    sequence(:title) { |n| "Конференция #{n}" }
    description { "Описание" }
    location { "Москва" }
    start_date { Date.current + 30 }
    end_date { Date.current + 32 }
    submission_deadline { Date.current + 15 }
    website_url { "https://example.com" }
    is_scopus { false }
    is_elibrary { false }
    association :creator, factory: :user
  end
end
