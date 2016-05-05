require 'spec_helper'

feature 'Standard Flow' do
  let(:haskell) { create(:haskell) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
        create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
            create(:exercise, name: 'Succ', description: 'Description of foo')
        ])
    ]) }

  before do
    visit '/'
  end

  scenario 'do a guide for first time, starting from home' do
    click_on 'Start Practicing!'

    click_on 'Start Practicing!'

    expect(page).to have_text('Succ')
  end

end
