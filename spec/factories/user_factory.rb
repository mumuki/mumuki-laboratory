FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:name) { |n| "#{Faker::Internet.user_name}#{n}" }
  end
end
