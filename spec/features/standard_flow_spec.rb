require 'spec_helper'

feature 'Standard Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {
    create(:exercise, name: 'Succ', guide: guide, position: 1, description: 'Description of foo')
  }
  let!(:chapter) { create(:chapter, name: 'Functional Programming') }
  let!(:guide) { create(:guide, name: 'getting-started', description: 'An awesome guide', language: haskell) }

  before { chapter.rebuild!([guide]) }

  before do
    visit '/'
  end

  scenario 'do a guide for first time, starting from home' do
    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    within('.chapter-panel') do
      click_on 'Start Practicing!'
    end

    click_on 'Start Practicing!'
    expect(page).to have_text('Succ')
  end

end
