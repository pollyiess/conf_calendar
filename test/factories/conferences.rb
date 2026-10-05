FactoryBot.define do
  factory :conference do
    title { "MyString" }
    description { "MyText" }
    start_date { "2026-10-05" }
    end_date { "2026-10-05" }
    submission_deadline { "2026-10-05" }
    location { "MyString" }
    website_url { "MyString" }
    is_scopus { false }
    is_elibrary { false }
    status { 1 }
  end
end
