require 'spec_helper'

feature 'Login Flow' do
  let!(:chapter) do
    create(:chapter, name: 'C1', lessons: [
      create(:lesson, language: create(:language), name: 'awesomeRubyGuide', description: 'rubist baz guide', exercises: [
        create(:exercise)
      ])
    ])
  end

  before { reindex_current_organization! }

  scenario 'can login' do
    visit '/'

    click_on 'Sign in'

    expect(page).to have_text('Start Practicing!')
    expect(page).to have_text('Content')
    expect(page).to have_text('Chapter')
    expect(page).to_not have_text('Sign in')
    expect(page).to have_text('Sign out')
  end

  scenario 'can login in non root' do
    visit '/guides/'

    click_on 'Sign in'

    expect(page).to have_text('Nobody created an exercise for this search yet')
  end

  scenario 'can logout' do
    visit '/'

    click_on 'Sign in'
    click_on 'Sign out'

    expect(page).to have_text('Content')
    expect(page).to have_text('Chapter')

    expect(page).to have_text('Sign in')
    expect(page).to_not have_text('Sign out')
  end

end
