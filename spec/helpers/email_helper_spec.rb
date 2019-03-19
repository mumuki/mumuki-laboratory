require 'spec_helper'

describe EmailHelper, organization_workspace: :test do
  helper EmailHelper

  describe 'page_title' do
    let(:user) { create(:user) }
    let(:guide) { create(:guide, name: 'A Guide') }
    let(:exercise) { create(:problem, name: 'An Exercise', guide: guide, number: 2) }
    let(:assignment) { exercise.submit_solution!(user, content: 'foo') }

    it { expect(assignment_help_email_body assignment).to eq "Exercise: An Exercise\n\nSolution:\nfoo\n\nStatus: failed\n\nSee http://test.localmumuki.io/exercises/#{exercise.transparent_id}\n" }
  end
end
