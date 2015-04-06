FactoryGirl.define do
  factory :user do
    name Faker::Internet.user_name
  end
end
