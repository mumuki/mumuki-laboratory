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

      context 'import_from_json' do
        let(:user) { create(:user, uid: 'auth0|1') }
        let(:user2) { create(:user, uid: 'auth0|2') }
        let(:guide) { create(:guide) }
        let(:exam_json) { { classroom_id: 1, slug: guide.slug, start_time: 5.minutes.ago, end_time: 10.minutes.since, duration: 150, language: 'haskell', name: 'foo', social_ids: [user.uid], tenant: 'test' }.stringify_keys }
        before { Exam.import_from_json! exam_json }

        context 'new exam' do
          it { expect(Exam.count).to eq 1 }
          it { expect(Exam.find_by(classroom_id: 1).accesible_by? user).to be true }
        end

        context 'existing exam' do
          let(:exam_json2) { { classroom_id: 1, slug: guide.slug, start_time: 5.minutes.ago, end_time: 10.minutes.since, duration: 150, language: 'haskell', name: 'foo', social_ids: [user2.uid], tenant: 'test' }.stringify_keys }
          before { Exam.import_from_json! exam_json2 }

          it { expect(Exam.count).to eq 1 }
          it { expect(Exam.find_by(classroom_id: 1).accesible_by? user).to be true }
          it { expect(Exam.find_by(classroom_id: 1).accesible_by? user2).to be true }
        end
      end
    end
  end
end
