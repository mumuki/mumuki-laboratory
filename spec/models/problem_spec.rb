require 'spec_helper'

describe Problem, organization_workspace: :test do

  context 'when no manual evaluation and' do
    before { problem.manual_evaluation = false }

    context 'when no test nor expectations' do
      let(:problem) { build(:problem, test: nil, expectations: []) }
      it { expect(problem.evaluation_criteria?).to be false }
    end

    context 'when no test but expectations' do
      let(:problem) { build(:problem, test: nil, expectations: [{inspection: 'HasBinding', binding: 'foo'}]) }
      it { expect(problem.evaluation_criteria?).to be true }
    end

    context 'when no expectations but test' do
      let(:problem) { build(:problem, test: 'describe ...', expectations: []) }
      it { expect(problem.evaluation_criteria?).to be true }
    end
  end

  context 'when is manual evaluation and' do
    before { problem.manual_evaluation = true }

    context 'when no test nor expectations' do
      let(:problem) { build(:problem, test: nil, expectations: []) }
      it { expect(problem.evaluation_criteria?).to be true }
    end

  end

  context 'when solving then failing' do
    let!(:problem) { create(:problem) }
    let!(:user) { create(:user) }

    before do
      assignment = problem.submit_solution!(user, content: 'foo')

      assignment.test_results = [{title: 'foo', result: '', status: :passed}]
      assignment.expectation_results = [{result: :passed, binding: 'foo', inspection: 'HasBinding'}]
      assignment.status = :passed
      assignment.save!

      @assignment = problem.submit_solution!(user, content: 'bar')
    end

    it { expect(@assignment.expectation_results).to eq [] }
    it { expect(@assignment.test_results).to eq nil }
    it { expect(@assignment.result).to eq 'noop result' }
    it { expect(@assignment.status).to eq :failed }
  end

  context 'when submit exercise with blank utf8 chars' do
    let!(:problem) { create(:problem) }
    let!(:user) { create(:user) }

    before do
      @assignment = problem.submit_solution!(user, content: "program {\n  Poner(Norte)\n}")
    end #                                                                ▲
    #                                                                    ╰ Blank unsupported UTF-8 char
    it { expect(@assignment.solution).to eq "program {\n  Poner(Norte)\n}" }
    #                                                    ▲
    #                                                    ╰ Normalized text / No blank UTF-8 char
  end

  context 'when submit exercise with non blank utf8 chars' do
    let!(:problem) { create(:problem) }
    let!(:user) { create(:user) }

    before do
      @assignment = problem.submit_solution!(user, content: "semáforo")
    end

    it { expect(@assignment.solution).to eq "semáforo" }

  end

end
