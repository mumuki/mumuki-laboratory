FactoryGirl.define do

  factory :lesson do
    sequence(:number)
    topic
    guide
  end

end
