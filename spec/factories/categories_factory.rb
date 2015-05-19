FactoryGirl.define do

  factory :category do
    description { Faker::Lorem.paragraph(2) }
    locale :en
    image_url 'http://localhost:3000/image'
  end

  factory :starting_point do
    language
    category
    guide
  end

end
