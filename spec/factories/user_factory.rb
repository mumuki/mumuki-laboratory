FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:name) { |n| "#{Faker::Internet.user_name}#{n}" }
  end
end
