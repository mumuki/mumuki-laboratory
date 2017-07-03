require 'spec_helper'

feature 'Standard Flow' do
  let!(:user) { create(:user, uid: 'mumuki@test.com') }
  let!(:user2) { create(:user, uid: 'johndoe@test.com') }
  let(:haskell) { create(:haskell) }
  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
        create(:lesson, name: 'Values and Functions', language: haskell, description: 'Values are everywhere...', exercises: [
            create(:exercise, name: 'The Basic Values', description: "Let's say we want to declare a variable...")
        ])
    ]) }
  before { reindex_current_organization! }

  before do
    visit '/'
  end

  scenario 'redirect to /user if profile uncompleted and has access to organizations' do
    OmniAuth.config.mock_auth[:developer] =
      OmniAuth::AuthHash.new provider: 'developer',
                             uid: 'mumuki@test.com',
                             credentials: {},
                             info: {}

    user.update! permissions: {student: 'test/*'}
    click_on 'Sign in'
    expect(page).to have_text('Please complete your profile data to continue!')
  end

  scenario 'do not redirect to /user if profile is complete' do
    user2.update! permissions: {student: 'test/*'}
    click_on 'Sign in'
    expect(page).not_to have_text('Please complete your profile data to continue!')
  end

  scenario 'do not redirect to /user if user do not have organizations' do
    click_on 'Sign in'
    expect(page).not_to have_text('Please complete your profile data to continue!')
  end

end
