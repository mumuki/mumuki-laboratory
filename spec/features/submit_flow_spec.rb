require 'spec_helper'

feature 'Submit Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercise1) { create(:problem, name: 'Succ1', guide: guide, number: 1, description: 'Description of foo', layout: :editor_right) }
  let!(:exercise2) { create(:problem, name: 'Succ2', guide: guide, number: 1, description: 'Description of foo', layout: :no_editor) }
  let!(:exercise3) { create(:problem, name: 'Succ3', guide: guide, number: 1, description: 'Description of foo', layout: :upload) }

  let!(:chapter) { create(:chapter, name: 'Functional Programming') }
  let!(:guide) { create(:guide, name: 'getting-started', description: 'An awesome guide', language: haskell) }

  let(:user) { create(:user) }

  before { chapter.rebuild!([guide]) }

  context 'logged user' do
    before { allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(user.id) }

    scenario 'Editor Right exercises' do
      visit "/exercises/#{exercise1.id}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'No Editor exercises' do
      visit "/exercises/#{exercise2.id}"

      expect(page).to have_text('Succ2')
      expect(page).to_not have_selector('.upload')

    end

    scenario 'Upload exercises' do
      visit "/exercises/#{exercise3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to have_selector('.upload')
    end
  end


  context 'not logged user' do
    scenario 'Upload exercises' do
      visit "/exercises/#{exercise3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to_not have_selector('.upload')
    end
  end

end
