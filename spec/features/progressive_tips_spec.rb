require 'spec_helper'

feature 'Progressive Tips' do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }

  let!(:problem) { build(:problem, name: 'Succ1', description: 'Description of Succ1', layout: :input_right, progressive_tips: [[5, 'try this'], [10, 'try that']] ) }
  let(:assignment) { problem.find_or_init_assignment_for(user) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [problem])
    ]) }

  before { reindex_current_organization! }

  context 'visit failed exercise' do
    before { set_current_user! user }
    before { assignment.update! status: :failed }

    scenario '2 failed submissions' do
      assignment.update! failed_submissions_count: 2
      visit "/exercises/#{problem.slug}"

      expect(page).to_not have_text('try this')
      expect(page).to_not have_text('try that')
    end

    scenario '5 failed submissions' do
      assignment.update! failed_submissions_count: 5
      visit "/exercises/#{problem.id}"

      expect(page).to have_text('try this')
      expect(page).to_not have_text('try that')
    end

    scenario '10 failed submissions' do
      assignment.update! failed_submissions_count: 10
      visit "/exercises/#{problem.id}"

      expect(page).to have_text('try this')
      expect(page).to have_text('try that')
    end
  end
end
