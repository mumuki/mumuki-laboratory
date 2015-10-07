require 'spec_helper'

describe ImportLog do
  let(:log) { ImportLog.new }

  describe 'pre validation errors' do
    before do
      log.no_description('isEven')
      log.no_meta('isEven')
    end

    it { expect(log.to_s).to eq 'Description does not exist for isEven, Meta does not exist for isEven' }
  end

  describe 'validation errors' do
    let(:problem) { build(:problem) }

    before do
      problem.test = nil
      problem.save
      log.saved(problem)
    end
    it { expect(log.to_s).to eq 'Saving A problem produced You need to provide either a test or an expectations file' }
  end
end
