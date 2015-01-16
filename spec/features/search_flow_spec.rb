require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercises) {
    create(:exercise, tag_list: ['haskell'], title: 'Foo', description: 'an awesome problem description')
    create(:exercise, tag_list: [], title: 'Bar', language: haskell)
    create(:exercise, tag_list: [], title: 'Baz', description: 'do it in haskell')
  }

  scenario 'search from home' do
    visit '/'

    within('.jumbotron') do
      click_on 'Start Practicing!'
    end

    fill_in 'q_language_name_or_title_or_description_or_locale_cont', with: 'haskell'
    click_on 'Search'

    expect(page).to have_text('Title')
    expect(page).to have_text('Bar')
    expect(page).to have_text('Baz')
    #expect(page).to have_text('Foo')
  end
end
