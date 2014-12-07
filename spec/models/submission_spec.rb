require 'spec_helper'

describe Submission do
  describe '#run_update!' do
    let(:exercise) { create(:exercise) }
    let(:submission) { exercise.submissions.create! }
    context 'when run passes' do
      before { submission.run_update! { ['ok', :passed] } }
      it { expect(submission.status).to eq('passed') }
      it { expect(submission.result).to eq('ok') }
    end
    context 'when run fails' do
      before { submission.run_update! { ['ups', :failed] } }
      it { expect(submission.status).to eq('failed') }
      it { expect(submission.result).to eq('ups') }
    end
    context 'when run aborts' do
      before do
        begin
          submission.run_update! { raise 'ouch' }
        rescue
        end
      end
      it { expect(submission.status).to eq('failed') }
      it { expect(submission.result).to eq('ouch') }
    end
  end
end
