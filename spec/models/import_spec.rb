require 'spec_helper'

describe Import do
  let(:import) { guide.imports.build }

  describe '#status' do
    let(:guide) { create(:guide) }

    it { expect(import.status).to eq 'pending' }
  end


  describe '#import_from_directory!' do
    let(:guide) { create(:guide) }
    let!(:haskell) { create(:haskell) }

    before { import.run_import_from_directory! 'spec/data/mumuki-sample-exercises' }

    it { expect(Exercise.count).to eq 2 }

    context 'when importing basic exercise' do
      let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 1) }

      it { expect(imported_exercise).to_not be nil }
      it { expect(imported_exercise.author).to eq guide.author }
      it { expect(imported_exercise.title).to eq 'Sample Title' }
      it { expect(imported_exercise.description).to eq '##Sample Description' }
      it { expect(imported_exercise.test).to eq 'pending' }
      it { expect(imported_exercise.extra_code).to eq "extra\n" }
      it { expect(imported_exercise.hint).to be nil }
      it { expect(imported_exercise.language).to eq haskell }
      it { expect(imported_exercise.expectations.size).to eq 2 }
      it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }
      it { expect(guide.description).to eq "Awesome guide\n"}
    end

    context 'when importing exercise with errors' do
      let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 2) }

      it { expect(imported_exercise).to be nil }
    end

    context 'when importing exercise with hint' do
      let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 3) }

      it { expect(imported_exercise).to_not be nil }
      it { expect(imported_exercise.hint).to eq "Try this: blah blah\n" }
    end
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

    it 'succeeds when repo is private'

    context 'when repository exists' do
      let(:guide) { create(:guide, github_repository: 'uqbar-project/mumuki-hspec-server') }

      it do
        expect(import.status).to eq 'passed'
        expect(import.result).to eq ''
      end
    end
  end
end
