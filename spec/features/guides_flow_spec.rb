require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {[
    create(:exercise, title: 'Foo',        guide: guide, position: 1, description: 'Description of foo'),
    create(:exercise, title: 'Bar',        guide: guide, position: 2),
    create(:exercise, title: 'Baz',        guide: guide, position: 4)
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

  scenario 'visits a guide, tries to check progress, signs in, checks progress' do
    visit "/guides/#{guide.id}"

    click_on 'Your Progress'

    expect(page).to have_text('You must sign in')

    within('.alert') do
      click_on 'sign in with Github'
    end

    expect(page).to have_text('Foo')
    expect(page).to have_text('Bar')
    expect(page).to have_text('Baz')
  end

  scenario 'resolve an exercise, then make it fail, then visit guide' do
    visit "/guides/#{guide.id}"

    click_on 'Sign in with Github'

    exercises[0].submissions.create!(status: :passed, submitter: user)
    exercises[1].submissions.create!(status: :passed, submitter: user)
    exercises[2].submissions.create!(status: :passed, submitter: user)

    exercises[2].submissions.create!(status: :failed, submitter: user)

    visit "/guides/#{guide.id}"

    #FIXME expect(page).to have_text('Continue')
  end


end
