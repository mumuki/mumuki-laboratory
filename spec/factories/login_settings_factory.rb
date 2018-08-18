FactoryBot.define do
  factory :all_login_settings, class: Mumukit::Login::Settings do
    login_methods { Mumukit::Login::Settings.login_methods }
  end
end
