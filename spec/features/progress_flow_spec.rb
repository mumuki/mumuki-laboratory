require 'spec_helper'

feature 'Progress Flow' do
  let!(:user) { create(:user) }
  let!(:functional) { create(:chapter, name: 'Functional Programming') }
  let!(:haskell) { create(:haskell) }
  let!(:first_guide) { create(:guide, name: 'HS Functional Programming First Guide') }
  let!(:exercise) { create(:exercise, guide: first_guide) }

  before { functional.rebuild!([first_guide]) }


  scenario 'user progress, not logged in, no submissions' do
    visit "/users/#{user.id}"

    expect(page).to have_text('Progress')
    expect(page).to_not have_text('Functional Programming')
  end

  scenario 'user progress, not logged in, with submissions' do
    exercise.submit_solution!(user, content: 'foo').failed!

    visit "/users/#{user.id}"

    expect(page).to have_text('Progress')
    expect(page).to have_text('Functional Programming')
  end

  scenario 'chapter progress, logged in' do
    visit '/'
    click_on 'Sign in'

    visit "/chapters/#{functional.id}"

    expect(page).to have_text('Progress')
    expect(page).to have_text('Functional Programming')
    expect(page).to have_text('HS Functional Programming First Guide')
  end

  scenario 'chapter progress, not logged in' do
    visit "/chapters/#{functional.id}"

    expect(page).to have_text('You must sign in before continue')
  end

end
