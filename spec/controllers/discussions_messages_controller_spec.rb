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

  describe 'delete' do
    let(:message) { create(:message, discussion: discussion, sender: student) }

    describe 'for student' do
      before { set_current_user! student }

      describe 'own message with permitted motive' do
        before do
          delete :destroy, params: {id: message.id, discussion_id: discussion.id, motive: :self_deleted}
          message.reload
        end

        it { expect(response.status).to eq 302 }
        it { expect(message.deleted?).to be true }
        it { expect(message.deleted_by).to eq student }
        it { expect(message.deleted_at).to_not eq nil }
        it { expect(message.deletion_motive).to eq 'self_deleted' }
      end

      describe 'own message with forbidden motive' do
        before do
          delete :destroy, params: {id: message.id, discussion_id: discussion.id, motive: :shares_solution}
          message.reload
        end

        it { expect(response.status).to eq 403 }
        it { expect(message.deleted?).to be false }
        it { expect(message.deleted_by).to eq nil }
        it { expect(message.deleted_at).to eq nil }
        it { expect(message.deletion_motive).to eq nil }
      end

      describe 'someone else\'s message' do
        let(:message) { create(:message, discussion: discussion, sender: moderator) }
        before do
          delete :destroy, params: {id: message.id, discussion_id: discussion.id, motive: :self_deleted}
          message.reload
        end

        it { expect(response.status).to eq 403 }
        it { expect(message.deleted?).to be false }
        it { expect(message.deleted_by).to eq nil }
        it { expect(message.deleted_at).to eq nil }
        it { expect(message.deletion_motive).to eq nil }
      end
    end

    describe 'for moderator' do
      before do
        set_current_user! moderator
        delete :destroy, params: {id: message.id, discussion_id: discussion.id, motive: :inappropriate_content}
        message.reload
      end

      it { expect(response.status).to eq 302 }
      it { expect(message.deleted?).to be true }
      it { expect(message.deleted_by).to eq moderator }
      it { expect(message.deleted_at).to_not eq nil }
      it { expect(message.deletion_motive).to eq 'inappropriate_content' }
    end
  end

  describe 'approve' do
    let(:message) { create(:message, discussion: discussion, sender: student) }

    describe 'for student' do
      before { set_current_user! student }
      before { post :approve, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 403 }
      it { expect(message.reload.approved).to be false }
    end

    describe 'for moderator' do
      before { set_current_user! moderator }
      before { post :approve, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 200 }
      it { expect(message.reload.approved).to be true }
    end
  end

  describe 'question' do
    let(:message) { create(:message, discussion: discussion, sender: student) }

    describe 'for student' do
      before { set_current_user! student }
      before { post :question, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 403 }
      it { expect(message.reload.not_actually_a_question).to be false }
    end

    describe 'for moderator' do
      before { set_current_user! moderator }
      before { post :question, params: {id: message.id, discussion_id: discussion.id} }

      it { expect(response.status).to eq 200 }
      it { expect(message.reload.not_actually_a_question).to be true }
    end

    describe 'preview' do
      let(:message) { create(:message, content: 'Message in **bold** and _italics_', discussion: discussion, sender: student) }

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
