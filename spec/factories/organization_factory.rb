FactoryGirl.define do

  factory :organization do
    private false
    login_methods Mumukit::Auth::LoginSettings.login_methods
    contact_email { Faker::Internet.email }
    book
  end

  factory :private_organization, class: Organization do
    contact_email { Faker::Internet.email }
    book
  end
end
