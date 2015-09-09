require 'spec_helper'

feature 'Submit Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercise) {
    create(:exercise, tag_list: ['haskell'], name: 'Foo', original_id: 1, description: 'an awesome problem description', guide: guide)
  }
  let!(:other_exercise) { create(:exercise, name: 'Baz', guide: guide, original_id: 2) }
  let(:guide) { create(:guide, corollary: 'Now you understand higher order programming') }


  scenario 'enter submissions page' do
    visit "/exercises/#{exercise.id}"

    click_on 'Sign in with Github'

    expect(page).to have_selector('#guide-done')
  end


  scenario 'create submission' do
    pending 'need to mock this'

    visit "/exercises/#{exercise.id}"

    click_on 'Sign in with Github'

    click_on 'Submit'

    expect(page).to have_text('We are processing you solution')
  end


  scenario 'create submission and then get another exercise' do
    pending 'need to mock this'

    visit "/exercises/#{exercise.id}"

    click_on 'Sign in with Github'

    click_on 'Submit'


    click_on 'Next'

    expect(page).to have_text('Baz')
  end


  scenario 'create submission and then retry exercise' do
    pending 'need to mock this'

    visit "/exercises/#{exercise.id}"

    click_on 'Sign in with Github'

    click_on 'Submit'


    expect(page).to have_text('Results')

    click_on 'Retry'

    expect(page).to have_text('Foo')
  end

end
