FactoryBot.define do

  factory :message do
    exercise_id { Faker::Internet.number(2) }
    assignment
    submission_id { assignment.id }
    sender { Faker::Internet.email }
    type { 'success' }
    content { Faker::Lorem.sentence(3) }
  end
end
