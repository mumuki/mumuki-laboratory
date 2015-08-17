require 'spec_helper'

feature 'Progress Flow' do
  let!(:user) { create(:user) }
  let!(:functional) { create(:category, name: 'Functional Programming') }
  let!(:haskell) { create(:haskell) }
  let!(:functional_haskell) { create(:path, language: haskell, category: functional) }
  let!(:first_guide) { create(:guide, path: functional_haskell, name: 'HS Functional Programming First Guide', position: 1) }
  let!(:exercise) { create(:exercise, guide: first_guide) }


  scenario 'user progress, not logged in, no submissions' do
    visit "/users/#{user.id}"

    expect(page).to have_text('Progress')
    expect(page).to_not have_text('Functional Programming')
  end

  scenario 'user progress, not logged in, with submissions' do
    exercise.submissions.create!(submitter: user, content: 'foo', status: :failed)

    visit "/users/#{user.id}"

    expect(page).to have_text('Progress')
    expect(page).to have_text('Functional Programming')
  end

  scenario 'path progress, logged in' do
    visit '/'
    click_on 'Sign in with Github'

    visit "/paths/#{functional_haskell.id}"

    expect(page).to have_text('Progress')
    expect(page).to have_text('Functional Programming')
    expect(page).to have_text('HS Functional Programming First Guide')
  end

  scenario 'path progress, not logged in' do
    visit "/paths/#{functional_haskell.id}"

    expect(page).to have_text('You must sign in before continue')
  end

end
