require 'spec_helper'

feature 'Profile Flow', organization_workspace: :test do
  let!(:user) { create(:user, uid: 'mumuki@test.com', first_name: nil, last_name: nil) }
  let(:haskell) { create(:haskell) }
  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
        build(:lesson, name: 'Values and Functions', language: haskell, description: 'Values are everywhere...', exercises: [
            build(:exercise, name: 'The Basic Values', description: "Let's say we want to declare a variable...")
        ])
    ]) }
  let(:problem) { create :problem}
  let(:message) {
    {'exercise_id' => problem.id,
     'submission_id' => problem.assignments.last.submission_id,
     'organization' => 'test-organization',
     'message' => {
       'sender' => 'test-email@gmail.com',
       'content' => 'a',
       'created_at' => '1/1/1'}} }
  let(:organization) { create(:organization, name: 'test-organization') }

  before do
    reindex_organization! organization
    reindex_current_organization!
  end

  before do
    OmniAuth.config.mock_auth[:developer] =
    OmniAuth::AuthHash.new provider: 'developer',
                           uid: user.uid,
                           credentials: {},
                           info: {}
  end

  before do
    visit '/'
  end

  context 'user with uncompleted profile' do
    scenario 'redirect to /user if user has access to organizations' do
      user.update! permissions: {student: 'test/*'}
      click_on 'Sign in'
      expect(page).to have_text('Please complete your profile data to continue!')
    end

    scenario 'redirect to /user if user does not have access to organizations' do
      click_on 'Sign in'
      expect(page).to have_text('Please complete your profile data to continue!')
    end

    scenario 'is able to log out', :element_not_interactable_error do
      click_on 'Sign in'
      set_automatic_login! false

      click_on 'Sign Out'
      expect(page).to_not have_text('Please complete your profile data to continue!')
      expect(page).to_not have_text('Sign Out')
      expect(page).to have_text('Sign In')
    end
  end

  context 'user with completed profile' do
    scenario 'do not redirect to /user' do
      user.update! first_name: 'Mercedes', last_name: 'Sosa', gender: 0, birthdate: Date.new(1935, 9, 7)
      click_on 'Sign in'
      expect(page).not_to have_text('Please complete your profile data to continue!')
    end
  end

  context 'logged in user' do
    before { set_current_user! user }

    context 'with no messages' do

      scenario 'visit messages tab' do
        visit "/user#messages"

        expect(page).to have_text('It seems you don\'t have any messages yet!')
      end
    end

    context 'with messages' do
      scenario 'visit messages tab' do
        Organization.find_by_name('test').switch!
        problem.submit_solution! user, {content: 'something'}
        Message.import_from_resource_h! message
        visit "/user#messages"

        expect(page).to_not have_text('It seems you don\'t have any messages yet!')
        expect(page).to have_text(problem.name)
      end
    end
  end

end
