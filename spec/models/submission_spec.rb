require 'spec_helper'

describe Submission do
  describe '#run_update!' do
    let(:submission) { create(:submission) }
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

  describe '#update_submissions_count!' do
    let(:exercise) { create(:exercise) }
    let(:user) { create(:user) }

    before do
      exercise.submissions.create!(submitter: user)
      exercise.submissions.create!(submitter: user)
      exercise.submissions.create!(submitter: user)
    end

    it { expect(exercise.reload.submissions_count).to eq(3) }


  end
end
