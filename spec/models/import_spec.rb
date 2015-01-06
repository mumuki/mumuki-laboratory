require 'spec_helper'

describe Import do
  let(:import) { guide.imports.build }

  describe '#status' do
    let(:guide) { create(:guide) }

    it { expect(import.status).to eq 'pending' }
  end


  describe '#import_from_directory!' do
    let(:guide) { create(:guide) }
    let!(:haskell) { create(:language, extension: 'hs') }

    before { import.run_import_from_directory! 'spec/data/mumuki-sample-exercises' }

    let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 1) }

    it { expect(imported_exercise).to_not be nil }
    it { expect(imported_exercise.author).to eq guide.author }
    it { expect(imported_exercise.title).to eq 'Sample Title' }
    it { expect(imported_exercise.description).to eq '##Sample Description' }
    it { expect(imported_exercise.test).to eq 'pending' }
    it { expect(imported_exercise.language).to eq haskell }
    it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }

  end

  describe '#import!' do
    before do
      begin
        import.run_import!
      rescue
      end
    end

    context 'when repository does not exist' do
      let(:guide) { create(:guide, github_repository: 'uqbar-project/foobar123456') }

      it do
        expect(import.status).to eq 'failed'
        expect(import.result).to eq 'Repository is private or does not exist'
      end
    end

    it 'fails if repo is private'
    it 'fails succeeds when repo is clonable'

    context 'when repository does not exist' do
      let(:guide) { create(:guide, github_repository: 'uqbar-project/mumuki-hspec-server') }

      it do
        expect(import.status).to eq 'passed'
        expect(import.result).to eq ''
      end
    end
  end
end
