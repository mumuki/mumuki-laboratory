require 'spec_helper'

feature 'Standard Flow' do
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

  scenario 'do an exercise for first time, starting from home' do
    expect(page).to have_text('Functional Programming')

    click_on 'Start Practicing!'

    expect(page).to have_text('Values and Functions')
    expect(page).to have_text('Values are everywhere...')
    expect(page).to have_text('Content')
    expect(page).to have_text('The Basic Values')
    expect(page).to have_text('Start Practicing!')
    expect(page).to_not have_text("Let's say we")
  end

end
