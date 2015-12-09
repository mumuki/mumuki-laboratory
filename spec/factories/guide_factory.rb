FactoryGirl.define do

  factory :guide do
    sequence(:name) { |n| "guide#{n}" }
    locale 'en'
    description 'A Guide'
    author { create(:user) }
    slug 'flbulgarelli/mumuki-sample-exercises'
    language
  end

end
