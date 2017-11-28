FactoryBot.define do

  factory :lesson, traits: [:guide_container] do
    sequence(:number)
    topic
  end
end
