FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { email }
    first_name { "Orlo" }
    last_name { Faker::Name.last_name }
  end
end
