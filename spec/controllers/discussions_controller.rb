require 'spec_helper'

describe DiscussionsController, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }
  let(:exercise_params) { {debatable_class: 'Exercise', exercise_id: exercise.id} }

  before { set_current_user! user }

  describe 'post' do
    before { allow_any_instance_of(DiscussionsController).to receive(:discussion_params).and_return title: 'A title' }
    before { post :create, params: exercise_params }

    it { expect(response.status).to eq 302 }
    it { expect(exercise.discussions.size).to eq 1 }
    it { expect(user.discussions.size).to eq 1 }
    it { expect(user.watched_discussions.size).to eq 1 }
  end

  describe 'index for debatable' do
    let(:initiator) { create(:user) }

    let!(:public_discussions) { [:opened, :solved].map { |it| create(:discussion, {status: it, initiator: initiator, item: exercise}) } }
    let!(:private_discussions) { [:pending_review, :closed].map { |it| create(:discussion, {status: it, initiator: initiator, item: exercise}) } }
    let!(:other_discussion) { create(:discussion, { status: :closed, item: exercise }) }

    subject { get :index, params: exercise_params }

    context 'as student' do
      before { subject }

      it { expect(response.status).to eq 200 }
      it { expect(assigns(:discussions)).to match_array public_discussions }
    end

    context 'as initiator' do
      before { set_current_user! initiator }
      before { subject }

      it { expect(response.status).to eq 200 }
      it { expect(assigns(:discussions)).to match_array public_discussions + private_discussions }
    end

    context 'as moderator' do
      let(:moderator) { create(:user, permissions: {moderator: 'private/*'}) }
      before { set_current_user! moderator }
      before { subject }

      it { expect(response.status).to eq 200 }
      it { expect(assigns(:discussions)).to match_array Discussion.all }
    end

    context 'without discussions' do
      let(:other_exercise) { create(:exercise) }
      before { get :index, params: exercise_params.merge(exercise_id: other_exercise.id) }

      it { expect(response.status).to eq 200 }
      it { expect(assigns(:discussions)).to be_empty }
    end
  end
end
