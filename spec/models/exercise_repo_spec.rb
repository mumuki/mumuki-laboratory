require 'spec_helper'

describe ExerciseRepo do
  let(:user) { create(:user) }
  let(:repo) { ExerciseRepo.new name: 'foo', author: user, github_url: 'flbulgarelli/mumuki-sample-exercises' }

  describe '#import_from_directory!' do

    before { repo.import_from_directory! 'spec/data/mumuki-sample-exercises' }

    let(:imported_exercise) { Exercise.find_by(origin_id: repo.id, original_id: 1) }

    it { expect(imported_exercise).to_not be nil }
    it { expect(imported_exercise.author).to eq user }
    it { expect(imported_exercise.title).to eq 'Sample Title' }
    it { expect(imported_exercise.description).to eq '##Sample Description' }
    it { expect(imported_exercise.test).to eq 'pending' }
    it { expect(imported_exercise.language).to eq 'haskell' }
    it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }

  end

  describe 'import!' do
    pending
  end

end
