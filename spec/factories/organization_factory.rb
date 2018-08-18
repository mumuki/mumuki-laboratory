FactoryBot.define do

  factory :organization do
    contact_email { Faker::Internet.email }
    description { 'a great org' }
    locale { 'en' }
    settings {}
    book
  end

  factory :base, parent: :organization do
    public { true }
    name { 'base' }
    login_methods { Mumukit::Login::Settings.login_methods }
  end

  factory :public_organization, parent: :organization do
    public { true }
    name { 'the-public-org' }
    login_methods { Mumukit::Login::Settings.login_methods }
  end

  factory :private_organization, parent: :organization do
    name { 'the-private-org' }
  end
end
