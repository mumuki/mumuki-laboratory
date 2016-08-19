FactoryGirl.define do

  factory :organization do
    contact_email { Faker::Internet.email }
    book
  end

  factory :public_organization, parent: :organization do
    private false
    login_methods Mumukit::Auth::LoginSettings.login_methods
  end

  factory :private_organization, parent: :organization do
  end
end
