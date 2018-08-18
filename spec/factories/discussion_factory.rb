FactoryBot.define do
  factory :discussion do
    title { 'A discussion' }
    description { 'A discussion description' }
    initiator { create(:user) }
    item { create(:exercise) }
  end
end
