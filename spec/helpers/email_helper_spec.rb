require 'spec_helper'

describe ApplicationHelper do
  helper ExerciseSolutionsHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    let(:user) { create(:user) }
    let(:guide) { create(:guide, name: 'A Guide') }
    let(:exercise) { create(:problem, name: 'An Exercise', guide: guide, number: 2) }
    let(:assignment) { exercise.submit_solution!(user, content: 'foo') }

    it { expect(assignment_help_email_body assignment).to eq "Exercise: An Exercise\n\nSolution:\nfoo\n\nStatus: failed\n\nSee http://test.host/guides/flbulgarelli/mumuki-sample-exercises\n" }
  end
end
