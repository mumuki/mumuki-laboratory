FactoryGirl.define do

  factory :guide do
    sequence(:name) { |n| "guide#{n}" }
    locale 'en'
    description 'A Guide'
    author { create(:user) }
    github_repository 'flbulgarelli/mumuki-sample-exercises'
  end

end
