require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercise) {
    create(:exercise, tag_list: ['haskell'], title: 'Foo', original_id: 1, description: 'an awesome problem description', guide: guide)
  }
  let!(:other_exercise) { create(:exercise, title: 'Baz', guide: guide, original_id: 2) }
  let(:guide) { create(:guide, corollary: 'Now you understand higher order programming') }

  scenario 'create submission' do
    visit "/exercises/#{exercise.id}"

    within '.actions' do
      click_on 'Sign in with Github'
    end

    click_on 'Submit'

    expect(page).to have_text('We are processing you solution')
  end


  scenario 'create submission and then get another exercise' do
    visit "/exercises/#{exercise.id}"

    within '.actions' do
      click_on 'Sign in with Github'
    end

    click_on 'Submit'

    pending

    click_on 'Next'

    expect(page).to have_text('Baz')
  end


  scenario 'create submission and then retry exercise' do
    visit "/exercises/#{exercise.id}"

    within '.actions' do
      click_on 'Sign in with Github'
    end

    click_on 'Submit'

    pending

    expect(page).to have_text('Results')

    click_on 'Retry'

    expect(page).to have_text('Foo')
  end

end
