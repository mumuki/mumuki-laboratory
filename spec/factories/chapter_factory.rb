FactoryGirl.define do

  factory :chapter do
    number { Faker::Number.digit }
    book { Organization.current.book }

    transient do
      lessons []
      name { Faker::Lorem.sentence(3) }
    end

    after(:build) do |chapter, evaluator|
      chapter.topic = build(:topic, name: evaluator.name, lessons: evaluator.lessons) unless evaluator.topic
    end
  end
end
