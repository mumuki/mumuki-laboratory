FactoryGirl.define do

  factory :guide do
    name 'guide1'
    description 'A Guide'
    author { create(:user) }
    github_repository 'flbulgarelli/mumuki-sample-exercises'
  end

end
