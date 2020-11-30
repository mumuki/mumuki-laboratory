require 'spec_helper'

describe DiscussionsController, organization_workspace: :test do
  let(:user) { create(:user, permissions: Mumukit::Auth::Permissions.parse(student: '*')) }
  let(:exercise) { create(:exercise) }
  let(:exercise_params) { {debatable_class: 'Exercise', exercise_id: exercise.id} }

  before { set_current_user! user }
  before { Organization.current.tap { |it| it.forum_enabled = true }.save! }

  describe 'show' do
    let(:another_orga) { create(:organization, {name: 'another_orga'}) }

    describe 'a discussion from the current orga' do
      let(:discussion) { create(:discussion, {organization: Organization.current}) }
      before {get :show, params: exercise_params.merge({id: discussion.id})}

      it {expect(response.status).to eq 200}
    end

    describe 'a discussion from another orga' do
      let(:discussion) { create(:discussion, {organization: another_orga}) }
      before {get :show, params: exercise_params.merge({id: discussion.id})}

      it {expect(response.status).to eq 404}
    end
  end

  describe 'index' do
    context 'when user is banned from forum' do
      before { user.update! banned_from_forum: true }
      before { get :index, params: exercise_params }

      it { expect(response.status).to eq 404 }
    end

    context 'when user has exam in progress' do
      let!(:exam) { create(:exam) }
      before { exam.authorize! user }
      before { exam.start! user }

      before { get :index, params: exercise_params }

      it { expect(response.status).to eq 403 }
    end
  end

  describe 'post' do
    before { allow_any_instance_of(DiscussionsController).to receive(:discussion_params).and_return title: 'A title' }
    before { post :create, params: exercise_params }

    it { expect(response.status).to eq 302 }
    it { expect(exercise.discussions.size).to eq 1 }
    it { expect(user.discussions.size).to eq 1 }
    it { expect(user.watched_discussions.size).to eq 1 }

    describe 'deleting exercises does delete all discussions' do
      before { @discussion_id = exercise.discussions.first.id }
      before { exercise.destroy }

      it { expect { Discussion.find(@discussion_id) }.to raise_exception(ActiveRecord::RecordNotFound) }
    end
  end

  describe 'when the minimal role for discussions is teacher' do
    before { Organization.current.tap { |it| it.forum_discussions_minimal_role = 'teacher' }.save! }

    describe 'and the user does not match the minimal role' do
      before { post :create, params: exercise_params }

      it { expect(response.status).to eq 404 }
    end

    describe 'and the user matches the minimal role' do
      let(:user) { create(:user, permissions: Mumukit::Auth::Permissions.parse(teacher: '*')) }
      before { allow_any_instance_of(DiscussionsController).to receive(:discussion_params).and_return title: 'A title' }
      before { post :create, params: exercise_params }

      it { expect(response.status).to eq 302 }
      it { expect(exercise.discussions.size).to eq 1 }
    end
  end
end
