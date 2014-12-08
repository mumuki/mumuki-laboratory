FactoryGirl.define do
  factory :submission do
    exercise
    submitter { create(:user) }
  end
end