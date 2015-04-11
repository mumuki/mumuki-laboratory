require 'spec_helper'

describe Export do
  let(:committer) { create(:user, token: '123456') }
  let(:haskell) { create(:haskell) }
  let!(:exercise_1) { create(:exercise, guide: guide, title: 'foo', original_id: 100, language: haskell) }
  let!(:exercise_2) { create(:exercise, guide: guide, title: 'bar', original_id: 200, language: haskell) }
  let(:guide) { create(:guide, description: 'Baz', github_repository: 'flbulgarelli/never-existent-repo') }
  let(:export) { guide.exports.create!(committer: committer) }


  describe '#status' do
    it { expect(export.status).to eq 'pending' }
  end

  describe 'create_guide_files' do
    let(:dir) { 'spec/data/export' }
    before do
      Dir.mkdir(dir)
      export.create_guide_files dir
    end

    after do
      FileUtils.rm_rf(dir)
    end

    it { expect(Dir.exist? 'spec/data/export/').to be true }

    it { expect(Dir.exist? 'spec/data/export/00100_foo/').to be true }
    it { expect(File.exist? 'spec/data/export/00100_foo/description.md').to be true }
    it { expect(File.exist? 'spec/data/export/00100_foo/test.hs').to be true }

    it { expect(Dir.exist? 'spec/data/export/00200_bar/').to be true }
    it { expect(File.exist? 'spec/data/export/00200_bar/description.md').to be true }
    it { expect(File.exist? 'spec/data/export/00200_bar/test.hs').to be true }

    it { expect(File.exist? 'spec/data/export/description.md').to be true }

    it { expect(Dir['spec/data/export/*'].size).to eq 3 }

  end

  describe '#run_export!' do
    context 'bad credentials' do
      before do
        begin
          export.run_export!
        rescue
        end
      end

      it do
        expect(export.status).to eq 'failed'
        expect(export.result).to include 'Bad credentials'
      end
    end
  end

end
