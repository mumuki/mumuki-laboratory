FactoryGirl.define do

  factory :guide do
    name 'A guide'
    author { create(:user) }
    github_repository 'flbulgarelli/mumuki-sample-exercises'
  end

end
