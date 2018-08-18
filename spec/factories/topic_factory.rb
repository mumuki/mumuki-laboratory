FactoryBot.define do

  factory :topic do
    name { Faker::Lorem::sentence(3) }
    description { Faker::Lorem.paragraph(2) }
    slug { "mumuki/mumuki-sample-topic-#{SecureRandom.uuid}" }
    locale { :en }
  end
end
