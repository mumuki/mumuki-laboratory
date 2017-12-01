require 'spec_helper'

describe ExerciseConfirmationsController do
  let(:user) { create(:user) }
  let(:reading) { create(:reading) }

  context 'when not authenticated' do
    before { post :create, params: { exercise_id: reading.id } }

    it { expect(response.status).to eq 403 }
  end

  context 'when authenticated' do
    before { set_current_user! user }
    before { post :create, params: { exercise_id: reading.id } }

    it { expect(response.status).to eq 200 }
    it { expect(response.body.parse_json).to json_like(status: :passed, result: '') }
  end
end
