require 'spec_helper'

feature 'Guide Reset Flow', organization_workspace: :test do
  let(:user) { create(:user) }

  let!(:problem) { build(:problem) }

  let!(:lesson) { create(:lesson, description: 'An awesome guide', exercises: [problem]) }

  let!(:chapter) { create(:chapter, lessons: [lesson]) }

  let(:exam_problem) { build(:problem) }
  let(:test_organization) { Organization.find_by_name('test') }
  let(:exam) { create(:exam, organization: test_organization, guide: guide) }
  let(:guide) { create(:guide, exercises: [exam_problem])}

  before { exam.index_usage! test_organization }

  before { reindex_current_organization! }

  let(:restart_xpath) { "//a[@title='#{I18n.t(:restart)}']" }

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

    scenario 'visit guide with solutions sent for it', :xpath_no_matches do
      problem.submit_solution! user

      visit "/lessons/#{lesson.id}"

      expect(page).to have_text('An awesome guide')
      expect(page).to have_xpath(restart_xpath)
    end

    scenario 'visit exam guide with solutions sent for it' do
      exam_problem.submit_solution! user
      exam.authorize!(user)

      visit "/exams/#{exam.id}"

      expect(page).to_not have_xpath(restart_xpath)
    end
  end
end
