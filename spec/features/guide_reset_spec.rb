require 'spec_helper'

feature 'Exercise Flow', organization_workspace: :test do
  let(:user) { create(:user) }

  let!(:problem) { build(:problem)}

  let!(:lesson) { create(:lesson, description: 'An awesome guide', exercises: [problem]) }

  let!(:chapter) { create(:chapter, lessons: [lesson]) }

  before { reindex_current_organization! }

  let(:restart_xpath) { "//i[@title='#{I18n.t(:restart)}']" }

  context 'no logged in user' do
    scenario 'visit guide' do
      visit "/lessons/#{lesson.id}"

      expect(page).to have_text('An awesome guide')
      expect(page).to_not have_xpath(restart_xpath)
    end
  end

  context 'logged in user' do
    before { set_current_user! user }

    scenario 'visit guide with no solutions sent for it' do
      visit "/lessons/#{lesson.id}"

      expect(page).to have_text('An awesome guide')
      expect(page).to_not have_xpath(restart_xpath)
    end

    scenario 'visit guide with solutions sent for it' do
      problem.submit_solution! user

      visit "/lessons/#{lesson.id}"

      expect(page).to have_text('An awesome guide')
      expect(page).to have_xpath(restart_xpath)
    end
  end
end
