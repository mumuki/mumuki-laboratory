require 'spec_helper'

feature 'Standard Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {
    create(:exercise, title: 'Succ', guide: guide, position: 1, description: 'Description of foo')
  }
  let!(:category) { create(:category, name: 'Functional Programming') }
  let!(:path) { create(:path, category: category, language: haskell) }
  let!(:guide) { create(:guide, name: 'getting-started', description: 'An awesome guide',
                        language: haskell, position: 1, path: path) }


  before do
    visit '/'
  end

  context 'single path' do
    scenario 'do a guide for first time, starting from home' do
      within('.jumbotron') do
        click_on 'Start Practicing!'
      end

      within('.category-panel') do
        click_on 'Start Practicing!'
      end

      click_on 'Start Practicing!'
      expect(page).to have_text('Succ')
    end
  end

  context 'multiple paths' do
    let(:js) { create(:language, name: 'js') }
    let!(:path_js) { create(:path, category: category, language: js) }
    let!(:guide_js) { create(:guide, name: 'getting-started-js', description: 'An awesome JS guide',
                             language: js, position: 1, path: path_js) }

    scenario 'do a guide for first time, starting from home' do
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


end
