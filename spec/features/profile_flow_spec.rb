require 'spec_helper'

feature 'Standard Flow', organization_workspace: :test do
  let!(:user) { create(:user, uid: 'mumuki@test.com', first_name: nil) }
  let!(:user2) { create(:user, uid: 'johndoe@test.com') }
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

  context 'logged in user' do
    before { set_current_user! user }

    context 'with no organizations nor messages' do
      scenario 'visit organizations tab' do
        visit "/user#organizations"

        expect(page).to have_text('It seems you aren\'t in any organizations yet!')
      end

      scenario 'visit messages tab' do
        visit "/user#messages"

        expect(page).to have_text('It seems you don\'t have any messages yet!')
      end
    end

    context 'with organizations and messages' do
      scenario 'visit organizations tab' do
        user.make_student_of! organization
        user.save!
        visit "/user#organizations"

        expect(page).to_not have_text('It seems you aren\'t in any organizations yet!')
        expect(page).to have_text('Go to test-organization')
      end

      scenario 'visit messages tab' do
        problem.submit_solution! user, {content: 'something'}
        Message.import_from_json! message
        visit "/user#messages"

        expect(page).to_not have_text('It seems you don\'t have any messages yet!')
        expect(page).to have_text(problem.name)
      end
    end
  end

end
