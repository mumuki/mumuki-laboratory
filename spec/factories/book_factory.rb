FactoryBot.define do
  factory :book do
    name { Faker::Lorem.sentence(3) }
    description { Faker::Lorem.sentence(30) }
    slug { "mumuki/mumuki-test-book-#{SecureRandom.uuid}" }
  end
end
