require 'spec_helper'

feature 'Exercise Flow' do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }

  let!(:exercise1) { build(:problem, name: 'Succ1', description: 'Description of Succ1', layout: :editor_right,) }
  let!(:exercise2) { build(:problem, name: 'Succ2', description: 'Description of Succ2', layout: :no_editor) }
  let!(:exercise3) { build(:problem, name: 'Succ3', description: 'Description of Succ3', layout: :upload) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
        exercise1, exercise2, exercise3
      ])
    ]) }

  before { reindex_current_organization! }

  context 'not logged user' do
    scenario 'visit exercise from search' do
      visit '/exercises'

      click_on 'Succ1'

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{exercise3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to_not have_selector('.upload')
    end
  end


  context 'logged user' do
    before { set_current_user! user }

    scenario 'visit exercise by id, editor right layout' do
      visit "/exercises/#{exercise1.id}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, no editor layout' do
      visit "/exercises/#{exercise2.id}"

      expect(page).to have_text('Succ2')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{exercise3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to have_selector('.upload')
    end
  end
end
