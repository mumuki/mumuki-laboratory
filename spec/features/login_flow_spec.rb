require 'spec_helper'

feature 'Login Flow', organization_workspace: :test do
  let!(:chapter) do
    create(:chapter, name: 'C1', lessons: [
      create(:lesson, language: create(:language), name: 'awesomeRubyGuide', description: 'rubist baz guide', exercises: [
        create(:exercise)
      ])
    ])
  end

  let!(:user) { create :user, first_name: 'John', last_name: 'Doe', uid: 'johndoe@test.com' }

  before { reindex_current_organization! }

  scenario 'can login' do
    visit '/'

    click_on 'Sign in'

    expect(page).to have_text('Start Practicing!')
    expect(page).to have_text('Chapters')
    expect(page).to_not have_text('Sign in')
    expect(page).to have_text('Sign Out')
  end

  scenario 'can login and keeps session', :navigation_error do
    visit '/'

    click_on 'Sign in'

    visit '/'

    expect(page).to_not have_text('Sign in')
    expect(page).to have_text('Sign Out')
  end

  scenario 'can login in non root' do
    visit "/chapters/#{chapter.id}"

    click_on 'Sign in'

    expect(page).to_not have_text('Sign in')
    expect(page).to have_text('Sign Out')
    expect(page).to have_text('C1')
  end

  scenario 'can logout', :element_not_interactable_error do
    visit '/'

    click_on 'Sign in'

    expect(page).to have_text('Sign Out')
    click_on 'Sign Out'

    expect(page).to have_text('Chapters')

    expect(page).to have_text('Sign in')
    expect(page).to_not have_text('Sign out')
  end

  scenario 'user can be prompted for login' do
    visit '/user'

    expect(page).to_not have_text('Sign in')
    expect(page).to have_text('Sign Out')
    expect(page).to have_text('My profile')
  end
end
