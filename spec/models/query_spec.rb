require 'spec_helper'

describe Query do
  let!(:exercise) { create(:exercise) }
  let(:user) { create(:user) }

  before do
    expect_any_instance_of(Exercise).to receive(:evaluation_class).and_return(Evaluation)
    allow_any_instance_of(Language).to receive(:run_query!).and_return(status: :passed, result: '5')
  end

  describe '#submit_query!' do
    let!(:results) { exercise.submit_query!(user, query: 'foo', content: 'bar') }
    let(:assignment) { exercise.assignment_for user }

    it { expect(results[:status]).to eq Status::Passed }
    it { expect(results[:result]).to eq '5' }
    it { expect(exercise.assigned_to? user).to be true }
    it { expect(assignment.solution).to eq 'bar' }
    it { expect(assignment.status).to eq Status::Pending }
  end
end
