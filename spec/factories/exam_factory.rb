FactoryGirl.define do

  factory :exam do
    guide
    duration { Faker::Number.between(10, 60).minutes }
    organization { Organization.current }
    start_time { 5.minutes.ago }
    end_time { 10.minutes.since }
  end
end
