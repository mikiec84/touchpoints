FactoryBot.define do
  factory :user do
    email { "webmaster@example.gov" }
    organization
    password { "password" }
    confirmed_at { Time.now }
    trait :admin do
      email { "admin@example.gov" }
      admin { true }
    end
  end
end
