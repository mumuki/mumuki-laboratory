FactoryGirl.define do
  factory :assignment do
    status Status::Pending
    exercise
    submitter { create(:user) }
  end
end
