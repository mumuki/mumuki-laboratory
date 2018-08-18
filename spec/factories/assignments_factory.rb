FactoryBot.define do
  factory :assignment do
    status { :pending }
    exercise
    submitter { create(:user) }
  end
end
