FactoryGirl.define do

  factory :complement, traits: [:guide_container] do
    book { Organization.book rescue nil }
  end
end
