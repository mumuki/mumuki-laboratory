FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    uid { Faker::Code.imei }
    sequence(:name) { |n| "#{Faker::Internet.user_name}#{n}" }
  end
end
