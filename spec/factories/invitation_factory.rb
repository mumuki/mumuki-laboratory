FactoryBot.define do
  factory :invitation do
    code { Faker::Lorem.sentence(6) }
    course { "foo/bar" }
    expiration_date { 5.minutes.since }
  end
end
