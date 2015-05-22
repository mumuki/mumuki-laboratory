require 'spec_helper'

feature 'Standard Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {
    create(:exercise, title: 'Succ',        guide: guide, position: 1, description: 'Description of foo')
  }
  let!(:category) { create(:category, name: 'Functional Programming') }
  let!(:path) { create(:path, category: category, language: haskell) }
  let!(:guide) { create(:guide, name: 'getting-started', description: 'An awesome guide',
                        language: haskell, position: 1, path: path) }

  scenario 'do a guide for first time, starting from home' do
    visit '/'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    within('.category-panel') do
      click_on 'haskell'
    end

    click_on 'Start Practicing!'

    expect(page).to have_text('Succ')
  end


end
