require 'spec_helper'

describe Import do
  let(:import) { guide.imports.build }

  describe '#status' do
    let(:guide) { create(:guide) }

    it { expect(import.status).to eq 'pending' }
  end


  describe '#read_guide!' do
    let(:guide) { create(:guide) }
    let!(:haskell) { create(:haskell) }

    context 'when guide is ok' do
      before do
        import.read_guide! 'spec/data/simple-guide'
        guide.reload
      end

      it { expect(Exercise.count).to eq 3 }
      it { expect(guide.description).to eq "Awesome guide\n" }
      it { expect(guide.language).to eq haskell }
      it { expect(guide.locale).to eq 'en' }

      context 'when importing basic exercise' do
        let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 1) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.author).to eq guide.author }
        it { expect(imported_exercise.title).to eq 'sample_title' }
        it { expect(imported_exercise.description).to eq '##Sample Description' }
        it { expect(imported_exercise.test).to eq 'pending' }
        it { expect(imported_exercise.extra_code).to eq "extra\n" }
        it { expect(imported_exercise.hint).to be nil }
        it { expect(imported_exercise.corollary).to be nil }
        it { expect(imported_exercise.language).to eq haskell }
        it { expect(imported_exercise.expectations.size).to eq 2 }
        it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }
        it { expect(guide.description).to eq "Awesome guide\n" }
        it { expect(imported_exercise.layout).to eq 'editor_right' }

      end

      context 'when importing exercise with errors' do
        let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 2) }

        it { expect(imported_exercise).to be nil }
      end

      context 'when importing exercise with hint and corollary' do
        let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 3) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.hint).to eq "Try this: blah blah\n" }
        it { expect(imported_exercise.corollary).to eq "And the corollary is...\n" }
      end


      context 'when importing with layout' do
        let(:imported_exercise) { Exercise.find_by(guide_id: guide.id, original_id: 4) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.layout).to eq 'editor_bottom' }
      end
    end
    context 'when guide is incomplete' do
      it 'fails an does not update guide' do
        expect { import.read_guide! 'spec/data/incompelete-guide' }.to raise_exception
        expect(guide.exercises_count).to eq 0
      end
    end
    context 'when guide has full data' do
      before do
        import.read_guide! 'spec/data/full-guide'
        guide.reload
      end

      it { expect(guide.exercises_count).to eq 1 }
      it { expect(guide.corollary).to eq "A guide's corollary\n" }
      it { expect(guide.learning).to be true }
      it { expect(guide.beta).to eq true }
      it { expect(guide.extra_code).to eq "A guide's extra code\n" }
    end
  end
end
