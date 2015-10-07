require 'spec_helper'

describe Problem do
  context 'when no test nor expectations' do
    let(:problem) { build(:problem, test: nil, expectations: []) }
    it { expect(problem.evaluation_criteria?).to be false }
  end

  context 'when no test but expectations' do
    let(:problem) { build(:problem, test: nil, expectations: [{inspection: 'HasBinding', binding: 'foo'}]) }
    it { expect(problem.evaluation_criteria?).to be true }
  end

  context 'when no test nor expectations' do
    let(:problem) { build(:problem, test: 'describe ...', expectations: []) }
    it { expect(problem.evaluation_criteria?).to be true }
  end
end
