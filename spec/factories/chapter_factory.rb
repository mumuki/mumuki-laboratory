FactoryGirl.define do

  factory :chapter do
    name { Faker::Lorem::sentence(3) }
    description { Faker::Lorem.paragraph(2) }
    number { Faker::Number.digit }
    locale :en
    image_url 'http://localhost:3000/image'
  end

end
