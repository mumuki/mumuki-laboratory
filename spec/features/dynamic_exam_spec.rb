require 'spec_helper'

feature 'Exercise Flow', organization_workspace: :test do
  let(:user) { create(:user, id: 1) }
  let(:user2) { create(:user, id: 2) }

  let!(:problem) { build(:problem, description: 'do f = $someVariable', randomizations: { someVariable: { type: :oneOf, value: %w(some_string some_other_string)} }) }

  let!(:chapter) {
    create(:chapter, lessons: [
      create(:lesson, description: 'An awesome guide', exercises: [
        problem
      ])
    ]) }

  before { reindex_current_organization! }

  context 'not logged user' do
    scenario 'visit exercise by slug' do
      visit "/exercises/#{problem.slug}"

      expect(page).to have_text('do f = some_string')
    end
  end


  context 'logged user' do
    scenario 'visit exercise by slug' do
      set_current_user! user
      visit "/exercises/#{problem.slug}"

      expect(page).to have_text('do f = some_other_string')

      set_current_user! user2
      visit "/exercises/#{problem.slug}"

      expect(page).to have_text('do f = some_string')
    end
  end
end
