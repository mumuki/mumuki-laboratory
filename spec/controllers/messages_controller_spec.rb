require 'spec_helper'

describe MessagesController, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }
  before { set_current_user! user }
  before { allow_any_instance_of(MessagesController).to receive(:message_params).and_return content: 'foo' }

  describe 'post when no previous assignment' do
    before { post :create, params: {exercise_id: exercise.id} }

    it { expect(response.status).to eq 302 }
    it { expect(user.assignments.size).to eq 1 }
    it { expect(user.direct_messages.size).to eq 1 }

    describe 'deleting exercises does delete all messages' do
      before { @message_id = user.direct_messages.first.id }
      before { exercise.destroy }

      it { expect { Message.find(@message_id) }.to raise_exception(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'post when previous assignment' do
    let(:assignment) { exercise.submit_solution!(user, content: '') }
    before { post :create, params: {exercise_id: exercise.id} }

    it { expect(response.status).to eq 302 }
    it { expect(user.assignments.size).to eq 1 }
    it { expect(user.direct_messages.size).to eq 1 }
  end
end
