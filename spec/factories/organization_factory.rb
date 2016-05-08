FactoryGirl.define do

  factory :organization do
    contact_email { Faker::Internet.email }
    book
  end
end
