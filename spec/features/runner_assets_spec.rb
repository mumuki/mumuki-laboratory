require 'spec_helper'

feature 'Runner Assets Flow', organization_workspace: :test do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }
  let(:gobstones) { create(:gobstones, layout_shows_loading_content: true, editor_shows_loading_content: true) }
  let(:bash) { create(:bash, layout_shows_loading_content: true) }

  let(:problem) { build(:problem, name: 'Succ', description: 'Description of Succ', editor: :code, language: gobstones) }
  let(:problem_2) { build(:problem, name: 'Succ2', description: 'Description of Succ2', editor: :custom, language: gobstones) }
  let(:problem_3) { build(:problem, name: 'Succ3', description: 'Description of Succ3', editor: :code, language: haskell) }
  let(:problem_4) { build(:problem, name: 'Succ4', description: 'Description of Succ4', editor: :code, language: bash) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
        problem, problem_2, problem_3, problem_4
      ])
    ]) }

  before { reindex_current_organization! }
  before { set_current_user! user }

  context 'loading assets script' do
    describe 'for language with both editor and layout loader' do
      scenario 'for exercise with code editor' do
        visit "/exercises/#{problem.id}"
        expect(page).to have_selector('#layout-loading-script', visible: false)
        expect(page).not_to have_selector('#editor-loading-script', visible: false)
      end

      scenario 'for exercise with custom editor' do
        visit "/exercises/#{problem_2.id}"
        expect(page).not_to have_selector('#layout-loading-script', visible: false)
        expect(page).to have_selector('#editor-loading-script', visible: false)
      end
    end

    describe 'for language without assets loader' do
      scenario 'for exercise with code editor' do
        visit "/exercises/#{problem_3.id}"
        expect(page).not_to have_selector('#layout-loading-script', visible: false)
        expect(page).not_to have_selector('#editor-loading-script', visible: false)
      end
    end

    describe 'for language with layout loader' do
      scenario 'for exercise with code editor' do
        visit "/exercises/#{problem_4.id}"
        expect(page).to have_selector('#layout-loading-script', visible: false)
        expect(page).not_to have_selector('#editor-loading-script', visible: false)
      end
    end
  end
end


