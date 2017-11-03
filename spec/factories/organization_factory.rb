FactoryGirl.define do

  factory :organization do
    contact_email { Faker::Internet.email }
    units { [] }

    transient do
      book { create(:book) }
    end

    after(:build) do |organization, evaluator|
      organization.units << evaluator.book.as_unit_of(organization)
    end
  end

  factory :public_organization, parent: :organization do
    public true
    login_methods Mumukit::Login::Settings.login_methods
  end

  factory :private_organization, parent: :organization do
  end
end
