require 'spec_helper'

describe ExerciseConfirmationsController, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:reading) { create(:reading, guide: create(:indexed_guide)) }

  context 'when not authenticated' do
    before { post :create, params: { exercise_id: reading.id } }

    it { expect(response.status).to eq 403 }
  end

  context 'when authenticated' do
    before { set_current_user! user }
    before { post :create, params: { exercise_id: reading.id } }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to json_like(guide_finished_by_solution: true) }
  end
end
