require 'spec_helper'

describe ApplicationHelper, organization_workspace: :test do
  helper ExerciseInputHelper

  describe 'should_render_message_input?' do
    let(:organization) { create(:organization, name: 'myorg', raise_hand_enabled: true) }

    let(:playground) { create(:playground) }
    let(:reading) { create(:reading) }
    let(:hidden) { create(:problem, editor: :hidden) }
    let(:upload) { create(:problem, editor: :upload) }
    let(:code) { create(:problem, editor: :code) }

    context 'when raise hand enabled' do
      it { expect(should_render_message_input? playground, organization).to be false }
      it { expect(should_render_message_input? reading, organization).to be false }
      it { expect(should_render_message_input? hidden, organization).to be false }
      it { expect(should_render_message_input? upload, organization).to be true }
      it { expect(should_render_message_input? code, organization).to be true }
    end
    context 'when raise hand disabled' do
      it { expect(should_render_message_input? code).to be_falsy }
    end
  end

  describe 'should_render_need_help_dropdown?' do
    let(:student) { create(:user, permissions: Mumukit::Auth::Permissions.parse(student: "*")) }
    let(:assignment) { create(:assignment, submitter: student) }

    context 'when the orga has a community link' do
      let(:organization) { create(:organization, name: 'myorg', community_link: 'com_link') }
      it { expect(should_render_need_help_dropdown? assignment, organization).to be true }
    end
    context 'when report issue enabled' do
      let(:organization) { create(:organization, name: 'myorg', report_issue_enabled: true) }
      it { expect(should_render_need_help_dropdown? assignment, organization).to be true }
    end
    context 'when forum enabled' do
      let(:organization) { create(:organization, name: 'myorg', forum_enabled: true) }
      it { expect(should_render_need_help_dropdown? assignment, organization).to be true }
    end
    context 'when forum enabled but the minimal role for discussions is teacher' do
      let(:organization) { create(:organization, name: 'myorg', forum_enabled: true, forum_discussions_minimal_role: 'teacher' ) }
      it { expect(should_render_need_help_dropdown? assignment, organization).to be false }
    end
    context 'when ask for help is not enabled' do
      it { expect(should_render_need_help_dropdown? assignment).to be false }
    end
    context 'when assignment passed' do
      let(:organization) { create(:organization, name: 'myorg', forum_enabled: true) }
      let(:assignment) { create(:assignment, status: :passed, exercise: create(:indexed_exercise)) }
      it { expect(should_render_need_help_dropdown? assignment, organization).to be false }
    end
  end

  describe 'should_render_problem_tabs?' do
    let(:student) { create(:user) }

    context 'on queriable languages' do
      let(:haskell) { create(:language, queriable: true) }

      let(:hidden) { create(:problem, editor: :hidden, language: haskell) }
      let(:upload) { create(:problem, editor: :upload, language: haskell) }
      let(:code) { create(:problem, editor: :code, language: haskell) }

      it { expect(should_render_problem_tabs? hidden, student).to be false }
      it { expect(should_render_problem_tabs? upload, student).to be true }
      it { expect(should_render_problem_tabs? code, student).to be true }
    end

    context 'on non queriable languages' do
      let(:gobstones) { create(:language, queriable: false) }
      let(:code) { create(:problem, editor: :code, language: gobstones) }

      context 'no messages' do
        it { expect(should_render_problem_tabs? code, student).to be false }
      end
      context 'with messages' do
        before { code.submit_question! student, content: 'Please help!' }
        it { expect(should_render_problem_tabs? code, student).to be true }
      end
    end
  end
end
