require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercises) {
    create(:exercise, tag_list: ['haskell'], title: 'Foo', description: 'an awesome problem description')
    create(:exercise, tag_list: [], title: 'Bar', language: haskell)
    create(:exercise, tag_list: [], title: 'haskelloid')
    create(:exercise, tag_list: [], title: 'Baz', description: 'do it in haskell')
    create(:exercise, tag_list: [], title: 'nothing', guide: guide)
  }
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'Haskelloid baz guide') }

  scenario 'search from home, by language' do
    visit '/'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    fill_in 'q', with: 'haskell'
    click_on 'search'

    expect(page).to have_text('Bar')
    expect(page).to have_text('Baz')
    expect(page).to have_text('Foo')
    expect(page).to have_text('haskelloid')
    expect(page).to_not have_text('nothing')

  end

  scenario 'search by guide' do
    visit '/en/exercises'

    fill_in 'q', with: 'awesomeGuide'
    click_on 'search'

    expect(page).to_not have_text('Bar')
    expect(page).to_not have_text('Baz')
    expect(page).to_not have_text('Foo')
    expect(page).to_not have_text('haskelloid')
    expect(page).to have_text('nothing')
  end

end
