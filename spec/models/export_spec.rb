require 'spec_helper'

describe Export do
  let(:committer) { create(:user) }
  let!(:exercise_1) { create(:exercise, guide: guide, title: 'foo') }
  let!(:exercise_2) { create(:exercise, guide: guide, title: 'bar') }


  describe '#status' do
    let(:guide) { create(:guide) }
    let(:export) { guide.exports.create!(committer: committer) }

    it { expect(export.status).to eq 'pending' }
  end

  describe '#run_export!' do
    let(:guide) { create(:guide, github_repository: 'flbulgarelli/never-existent-repo') }
    let(:export) { guide.exports.create!(committer: committer) }

    before do
      begin
        export.run_export!
      rescue
      end
    end

    it do
      expect(export.status).to eq 'failed'
      expect(export.result).to eq 'Repository is private or does not exist'
    end
  end

end
