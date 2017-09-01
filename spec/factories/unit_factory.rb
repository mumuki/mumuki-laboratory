FactoryGirl.define do
  factory :unit do
    number { Faker::Number.between(1, 40) }
    book { Organization.current.first_book rescue nil }
    projects []
    complements []
  end
end
