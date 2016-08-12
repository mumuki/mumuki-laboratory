FactoryGirl.define do
  factory :all_login_settings, class: Mumukit::Auth::LoginSettings do
    login_methods Mumukit::Auth::LoginSettings.login_methods
  end
end
