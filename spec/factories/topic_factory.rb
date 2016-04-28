FactoryGirl.define do

  factory :topic do
    name { Faker::Lorem::sentence(3) }
    description { Faker::Lorem.paragraph(2) }
    locale :en
  end
end
