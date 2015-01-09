require 'spec_helper'

describe ExerciseRepository do
  let(:author) { create(:user) }
  let(:log) { ImportLog.new }
  let(:repo) { ExerciseRepository.new(author, 'spec/data/mumuki-sample-exercises') }
  let!(:haskell) { create(:language, extension: 'hs') }
  let(:results) { [] }

  before { repo.process_files(log) { |it| results << it } }

  it { expect(results.size).to eq 1 }
  it { expect(log.messages).to eq ['Description does not exist for sample_broken'] }

end
