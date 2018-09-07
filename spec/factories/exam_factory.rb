FactoryBot.define do

  factory :exam, traits: [:guide_container] do
    duration { Faker::Number.between(10, 60).minutes }
    organization { Organization.current }
    start_time { 5.minutes.ago }
    end_time { 10.minutes.since }
  end
end
