require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {[
    create(:exercise, name: 'Foo',        guide: guide, position: 1, description: 'Description of foo'),
    create(:exercise, name: 'Bar',        guide: guide, position: 2),
    create(:exercise, name: 'Baz',        guide: guide, position: 4)
  ]}
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'An awesome guide', language: haskell) }
  let(:user) { User.find_by(name:'testuser') }

  scenario 'visit guides from search page, signs in, and starts practicing' do
    visit '/'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    click_on 'Guides'

    click_on 'awesomeGuide'

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('An awesome guide')
    expect(page).to have_text('About this guide')

    click_on 'Start Practicing'

    expect(page).to have_text('Description of foo')
  end
end
