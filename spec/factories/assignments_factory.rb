FactoryBot.define do
  factory :assignment do
    status Mumuki::Laboratory::Status::Pending
    exercise
    submitter { create(:user) }
  end
end
