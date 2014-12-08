require 'spec_helper'

describe TestRunning do

  describe '#perform' do
    let(:exercise) { create(:x_equal_5_exercise) }
    let(:user) { exercise.author }

    before { submission.run_tests! }

    context 'when submission is ok' do
      let(:submission) { create(:submission, exercise: exercise, content: 'x = 5') }
      it { expect(submission.reload.status).to eq('passed') }
      it { expect(submission.reload.result).to include('0 failures') }
    end

    context 'when submission is not ok' do
      let(:submission) { create(:submission, exercise: exercise, content: 'x = 2')}
      it { expect(submission.reload.status).to eq('failed') }
      it { expect(submission.reload.result).to include("should be equal 5 FAILED") }
    end

  end
end
