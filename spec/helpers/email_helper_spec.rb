require 'spec_helper'

describe ApplicationHelper do
  helper ExerciseSolutionsHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    let(:user) { create(:user) }
    let(:guide) { create(:guide, name: 'A Guide') }
    let(:exercise) { create(:problem, name: 'An Exercise', guide: guide, number: 2) }
    let(:assignment) { exercise.submit_solution!(user) }

    it { expect(assignment_help_email_body assignment).to eq "Exercise:\nAn Exercise\n\nsolution:\n\n\nStatus:\nfailed" }
  end

end
