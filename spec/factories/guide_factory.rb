FactoryGirl.define do

  factory :guide do
    sequence(:name) { |n| "guide#{n}" }
    description 'A Guide'
    author { create(:user) }
    github_repository 'flbulgarelli/mumuki-sample-exercises'
  end

end
