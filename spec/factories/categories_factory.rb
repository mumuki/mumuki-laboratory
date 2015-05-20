FactoryGirl.define do

  factory :category do
    description { Faker::Lorem.paragraph(2) }
    locale :en
    image_url 'http://localhost:3000/image'
  end

  factory :path do
    language
    category
    name { Faker::Lorem::sentence(3) }
  end

end
