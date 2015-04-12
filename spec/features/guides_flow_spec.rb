require 'spec_helper'

feature 'Search Flow' do
  before { I18n.locale = :en }

  let(:haskell) { create(:haskell) }
  let!(:exercises) {
    create(:exercise, title: 'Foo',        guide: guide, original_id: 1, language: haskell, description: 'Description of foo')
    create(:exercise, title: 'Bar',        guide: guide, original_id: 2)
    create(:exercise, title: 'Baz',        guide: guide, original_id: 4)
  }
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'An awesome guide') }

  scenario 'visit guides from search page, signs in, and starts practicing' do
    visit '/en'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    click_on 'Guides'

    click_on 'awesomeGuide'

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('An awesome guide')
    expect(page).to have_text('About this guide')

    within('.actions') do
      click_on 'Sign in with Github'
    end

    click_on 'Start Practicing'

    expect(page).to have_text('Description of foo')
  end

  scenario 'visits a guide, tries to check progress, signs in, checks progress' do
    visit "/en/guides/#{guide.id}"

    click_on 'Your Progress'

    expect(page).to have_text('You must sign in')

    within('.alert') do
      click_on 'sign in with Github'
    end

    expect(page).to have_text('Foo')
    expect(page).to have_text('Bar')
    expect(page).to have_text('Baz')
  end


end
