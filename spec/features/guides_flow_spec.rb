require 'spec_helper'

feature 'Search Flow' do
  before { I18n.locale = :en }

  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercises) {
    create(:exercise, title: 'Foo',        guide: guide, original_id: 1, language: haskell, description: 'Description of foo')
    create(:exercise, title: 'Bar',        guide: guide, original_id: 2)
    create(:exercise, title: 'haskelloid', guide: guide, original_id: 3)
    create(:exercise, title: 'Baz',        guide: guide, original_id: 4)
    create(:exercise, title: 'nothing',    guide: guide, original_id: 5)
  }
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'Haskelloid baz guide') }

  scenario 'visit guides from search page, signs in, and starts practicing' do
    visit '/en'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    click_on 'Guides'

    click_on 'awesomeGuide'

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('About this guide')

    within('.actions') do
      click_on 'Sign in with Github'
    end

    click_on 'Start Practicing'

    expect(page).to have_text('Description of foo')
  end
end
