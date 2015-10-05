require 'spec_helper'

describe ExerciseRepository do
  let(:author) { create(:user) }
  let(:log) { ImportLog.new }
  let(:repo) { ExerciseRepository.new(author, haskell, 'spec/data/simple-guide') }
  let(:haskell) { create(:haskell) }
  let(:results) { [] }

  before { repo.process_files(log) { |it| results << it } }

  it { expect(results.size).to eq 4 }
  it { expect(log.messages).to eq ['Description does not exist for sample_broken'] }

end
