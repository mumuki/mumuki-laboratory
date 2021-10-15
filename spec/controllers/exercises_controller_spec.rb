require 'spec_helper'

describe ExercisesController, organization_workspace: :test do
  let(:user) { create(:user) }

  let(:problem) { create(:problem) }
  let!(:exam) { create :exam, exercises: [problem], duration: 10, start_time: 1.hour.ago, end_time: 1.hour.since }

  before { reindex_current_organization! }
  before { set_current_user! user }


  describe 'show' do
    context 'when user is in the middle of an exam' do

      let!(:exam_authorization) { create :exam_authorization, exam: exam, user: user, started: true, started_at: started_at }
      before { get :show, params: { id: problem.id } }

      context 'when user is not out of time yet' do
        let(:started_at) { 5.minutes.ago }

        it { expect(response.status).to eq 200 }
      end

      context 'when user is out of time' do
        let(:started_at) { 20.minutes.ago }

        it { expect(response.status).to eq 410 }
      end
    end
  end
end
