FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    uid { email }
    sequence(:name) { |n| "#{Faker::Internet.user_name}#{n}" }
  end
end
