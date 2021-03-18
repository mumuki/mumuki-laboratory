require 'spec_helper'

describe DiscussionsMessagesController, type: :controller, organization_workspace: :test do
  let(:student) { create(:user, permissions: {student: 'test/*'}) }
  let(:moderator) { create(:user, permissions: {moderator: 'test/*', student: 'test/*'}) }

  let(:exercise) { create(:exercise) }
  let(:discussion) { create(:discussion, item: exercise, organization: Organization.current) }

  before { Organization.current.update! forum_enabled: true }

  describe 'post' do
    describe 'for student' do
      before { set_current_user! student }
      before { allow_any_instance_of(DiscussionsMessagesController).to receive(:message_params).and_return content: 'Need help' }
      before { post :create, params: {discussion_id: discussion.id} }

      it { expect(response.status).to eq 302 }
      it { expect(discussion.messages.size).to eq 1 }
      it { expect(discussion.messages.last.content).to eq 'Need help' }
    end

    describe 'for moderator' do
      before { set_current_user! moderator }
      before { allow_any_instance_of(DiscussionsMessagesController).to receive(:message_params).and_return content: 'Do this!' }
      before { post :create, params: {discussion_id: discussion.id} }

      it { expect(response.status).to eq 302 }
      it { expect(discussion.messages.size).to eq 1 }
      it { expect(discussion.messages.last.content).to eq 'Do this!' }
    end
  end

  describe 'approve' do
    let(:message) { create(:message, discussion: discussion, sender: student.uid) }

    describe 'for student' do
      before { set_current_user! student }
      before { post :approve, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 403 }
      it { expect(message.reload.approved).to be false }
    end

    describe 'for student' do
      before { set_current_user! moderator }
      before { post :approve, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 200 }
      it { expect(message.reload.approved).to be true }
    end
  end

  describe 'question' do
    let(:message) { create(:message, discussion: discussion, sender: student.uid) }

    describe 'for student' do
      before { set_current_user! student }
      before { post :question, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 403 }
      it { expect(message.reload.not_actually_a_question).to be false }
    end

    describe 'for student' do
      before { set_current_user! moderator }
      before { post :question, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 200 }
      it { expect(message.reload.not_actually_a_question).to be true }
    end

    describe 'preview' do
      let(:message) { create(:message, content: 'Message in **bold** and _italics_', discussion: discussion, sender: student.uid) }

      describe 'for student' do
        before { set_current_user! student }
        before { get :preview, params: {content: message.content} }

        it { expect(response.status).to eq 403 }
      end

      describe 'for moderator' do
        before { set_current_user! moderator }
        before { get :preview, params: {content: message.content} }

        it { expect(response.status).to eq 200 }
        it { expect(JSON.parse(response.body)['preview']).to eq "<p>Message in <strong>bold</strong> and <em>italics</em></p>\n" }
      end
    end
  end
end
