FactoryGirl.define do

  factory :lesson do
    sequence(:number)
    topic

    transient do
      exercises []
      name { Faker::Lorem.sentence(3) }
      description { Faker::Lorem.sentence(10) }
      language { create(:language) }
      slug { "mumuki/mumuki-test-lesson-#{SecureRandom.uuid}" }
    end

    after(:build) do |lesson, evaluator|
      lesson.guide = build(:guide,
                           name: evaluator.name,
                           slug: evaluator.slug,
                           exercises: evaluator.exercises,
                           description: evaluator.description,
                           language: evaluator.language) unless evaluator.guide
    end
  end
end
