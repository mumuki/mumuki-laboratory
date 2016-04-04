FactoryGirl.define do

  factory :comment do
    exercise_id { Faker::Internet.number(2) }
    assignment
    submission_id { assignment.id }
    author { Faker::Internet.email }
    type 'success'
    date { Faker::Date.forward(1) }
    content {Faker::Lorem.sentence(3) }
  end
end
