FactoryGirl.define do
  factory :solution do
    status Status::Pending
    exercise
    submitter { create(:user) }
  end
end
