require 'spec_helper'

describe TestRunnerJob do

  describe '#perform' do
    let(:exercise) { create(:exercise) }
    before { TestRunnerJob.new.perform(submission.id) }

    context 'when submission is ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to equal(:passed) }
      it { expect(submission.reload.result.to equal('TODO')) }
    end

    context 'when submission is not ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to equal(:failed) }
      it { expect(submission.reload.result.to equal('TODO')) }
    end

  end
end
