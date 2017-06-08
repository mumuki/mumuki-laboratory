require 'spec_helper'

describe MessagesController do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }
  before { set_current_user! user }
  before { allow_any_instance_of(MessagesController).to receive(:message_params).and_return content: 'foo' }

  describe 'post when no previous assignment' do
    before { post :create, {exercise_id: exercise.id} }

    it { expect(response.status).to eq 302 }
    it { expect(user.assignments.size).to eq 1 }
    it { expect(user.messages.size).to eq 1 }
  end

  describe 'post when previous assignment' do
    let(:assignment) { exercise.submit_solution!(user, content: '') }
    before { post :create, {exercise_id: exercise.id} }

    it { expect(response.status).to eq 302 }
    it { expect(user.assignments.size).to eq 1 }
    it { expect(user.messages.size).to eq 1 }
  end
end
