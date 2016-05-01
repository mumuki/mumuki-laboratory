FactoryGirl.define do

  factory :exam do
    guide
    duration { Faker::Number.between(10, 60).minutes }
  end
end
