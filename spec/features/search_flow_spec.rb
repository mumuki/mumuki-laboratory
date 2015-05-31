require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let(:ruby) { create(:language, name: 'Ruby') }

  let!(:exercises) {
    create(:exercise, tag_list: ['haskell'], title: 'Foo', description: 'an awesome problem description')
    create(:exercise, tag_list: [], title: 'Bar', language: haskell)
    create(:exercise, tag_list: [], title: 'haskelloid')
    create(:exercise, tag_list: [], title: 'Baz', description: 'do it in haskell')
    create(:exercise, tag_list: [], title: 'nothing', guide: guide)
  }
  let(:guide) { create(:guide, language: ruby, name: 'awesomeRubyGuide', description: 'rubist baz guide') }


  scenario 'search guides from home, by language' do
    visit '/'

    click_on 'Guides'

    fill_in 'q', with: 'ruby'
    click_on 'search'

    expect(page).to have_text('awesomeRubyGuide')

  end


  scenario 'search by language' do
    visit '/exercises'

    fill_in 'q', with: 'haskell'
    click_on 'search'

    expect(page).to have_text('Bar')
    expect(page).to have_text('Baz')
    expect(page).to have_text('Foo')
    expect(page).to have_text('haskelloid')
    expect(page).to_not have_text('nothing')

  end

  scenario 'search by guide' do
    visit '/exercises'

    fill_in 'q', with: 'awesomeRubyGuide'
    click_on 'search'

    expect(page).to_not have_text('Bar')
    expect(page).to_not have_text('Baz')
    expect(page).to_not have_text('Foo')
    expect(page).to_not have_text('haskelloid')
    expect(page).to have_text('nothing')
  end


  scenario 'search by guide when it does not exists' do
    visit '/exercises'

    click_on 'Sign in with Github'

    fill_in 'q', with: 'nonExistingExercise'

    click_on 'search'

    expect(page).to have_text('Be the first')

    click_on 'Be the first'

    expect(page).to have_text('New Exercise')

    expect(find_field('exercise_title').value).to eq 'nonExistingExercise'
  end

end
