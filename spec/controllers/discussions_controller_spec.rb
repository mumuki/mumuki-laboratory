require 'spec_helper'

describe DiscussionsController, organization_workspace: :test do
  let(:user) { create(:user, permissions: Mumukit::Auth::Permissions.parse(student: '*')) }
  let(:exercise) { create(:exercise) }
  let(:exercise_params) { {debatable_class: 'Exercise', exercise_id: exercise.id} }

  before { set_current_user! user }
  before { Organization.current.tap { |it| it.forum_enabled = true }.save! }

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
