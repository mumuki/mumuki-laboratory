require 'spec_helper'

feature 'Standard Flow' do
  before { I18n.locale = :en }

  let(:haskell) { create(:haskell) }
  let!(:exercises) {
    create(:exercise, title: 'Succ',        guide: guide, position: 1, description: 'Description of foo')
  }
  let!(:guide) { create(:guide, name: 'getting-started', description: 'An awesome guide', language: haskell) }
  let!(:category) { create(:category, name: 'Functional Programming') }
  let!(:starting_point) { create(:starting_point, category: category, guide: guide, language: haskell) }

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
