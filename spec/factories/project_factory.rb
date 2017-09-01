FactoryGirl.define do

  factory :project, traits: [:guide_container] do
    unit { Organization.current.first_unit }
  end
end
