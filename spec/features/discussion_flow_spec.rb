require 'spec_helper'

feature 'Discussion Flow', organization_workspace: :test do
  let(:student) { create(:user, permissions: {student: 'test/*'}) }
  let(:moderator) { create(:user, permissions: {moderator: 'test/*', student: 'test/*'}) }

  let(:problem_1) { create(:indexed_exercise) }
  let(:problem_2) { create(:indexed_exercise) }

  shared_examples 'no forum access' do
    scenario 'has no forum access' do
      visit "/exercises/#{problem_1.transparent_id}/discussions"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  context 'with no current user' do
    it_behaves_like 'no forum access'
  end

  context 'with logged user' do
    before { set_current_user! student }

    it_behaves_like 'no forum access'
  end

  context 'with logged user' do
    before { set_current_user! student }

    it_behaves_like 'no forum access'
  end
end
