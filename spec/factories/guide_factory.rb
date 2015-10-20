FactoryGirl.define do

  factory :guide do
    sequence(:name) { |n| "guide#{n}" }
    locale 'en'
    description 'A Guide'
    author { create(:user) }
    url 'http://guides.mumuki.io/flbulgarelli/mumuki-sample-exercises'
    language
  end

end
