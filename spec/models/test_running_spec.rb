require 'spec_helper'

describe TestRunning do

  describe '#run_tests!' do
    let(:exercise) { create(:x_equal_5_exercise, expectations: [
        Expectation.new(binding: :foo, inspection: :HasComposition)]) }
    let(:user) { exercise.author }

    before { expect(submission.language).to receive(:run_tests!).and_return(server_response) }
    before { submission.run_tests! }

    context 'when submission is ok' do
      let(:submission) { create(:submission, exercise: exercise) }
      let(:server_response) { ['0 failures', :passed] }

      it { expect(submission.reload.status).to eq('passed') }
      it { expect(submission.reload.result).to include('0 failures') }
    end

    context 'when submission is ok and has expectations' do
      let(:submission) { create(:submission,
                                exercise: exercise) }
      let(:server_response) { ['0 failures', :passed] }

      it { expect(submission.reload.status).to eq('passed') }
      it { expect(submission.reload.result).to include('0 failures') }
    end

    context 'when submission is not ok' do
      let(:submission) { create(:submission, exercise: exercise)}
      let(:server_response) { ['should be equal 5 FAILED', :failed] }

      it { expect(submission.reload.status).to eq('failed') }
      it { expect(submission.reload.result).to include('should be equal 5 FAILED') }
    end

  end
end
