require 'spec_helper'

describe Exam do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '#accesible_by?' do
    context 'not enabled' do
      let(:exam) { create(:exam, start_time: 5.minutes.since, end_time: 10.minutes.since) }

      it { expect(exam.enabled?).to be false }

      context 'not authorized' do
        it { expect(exam.accesible_by? user).to be false }
      end

      context 'authorized' do
        it { expect(exam.enabled?).to be false }
      end
    end

    context 'enabled' do
      let(:exam) { create(:exam, start_time: 5.minutes.ago, end_time: 10.minutes.since) }

      it { expect(exam.enabled?).to be true }

      context 'not authorized' do
        it { expect(exam.accesible_by? user).to be false }
      end

      context 'authorized' do
        before { exam.authorize! user }

        it { expect(exam.accesible_by? user).to be true }
        it { expect(exam.accesible_by? other_user).to be false }
      end
    end
  end
end