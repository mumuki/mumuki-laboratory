FactoryGirl.define do

  factory :lesson do
    sequence(:number)
    chapter
    guide
  end

end
