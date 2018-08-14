require 'spec_helper'

describe DiscussionsController, organization_workspace: :test do
  let(:user) { create(:user) }
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
  end
end
