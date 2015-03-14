require 'spec_helper'

feature 'Search Flow' do
  let(:haskell) { create(:language, name: 'Haskell') }
  let!(:exercise) {
    create(:exercise, tag_list: ['haskell'], title: 'Foo', description: 'an awesome problem description', guide: guide)
  }
  let!(:other_exercise) { create(:exercise, title: 'Baz', guide: guide) }
  let(:guide) { create(:guide) }

  scenario 'create submission' do
    visit "/en/exercises/#{exercise.id}"

    click_on 'sign in with Github'

    click_on 'Submit your solution!'

    expect(page).to have_text("Submission was successfully created")
  end


  scenario 'create submission and then get another exercise' do
    visit "/en/exercises/#{exercise.id}"

    click_on 'sign in with Github'

    click_on 'Submit your solution!'

    click_on 'Gimme another exercise!'

    expect(page).to have_text("Baz")
  end

end
