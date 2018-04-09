require 'spec_helper'

feature 'Lessons Flow', organization_workspace: :test do
  let(:lesson_not_in_path) { create(:lesson) }

  before { reindex_current_organization! }

  let(:user) { User.find_by(name: 'testuser') }

  context 'inexistent lesson' do
    scenario 'visit lesson by id, not in path' do
      visit "/lessons/#{lesson_not_in_path.id}"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit lesson by id, unknown lesson' do
      visit '/lessons/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end
end
