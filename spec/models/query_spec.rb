require 'spec_helper'

describe Query do
  let!(:exercise) { create(:exercise) }
  let(:user) { create(:user) }

  before do
    expect_any_instance_of(Exercise).to receive(:evaluation_class).and_return(Evaluation)
    allow_any_instance_of(Language).to receive(:run_query!).and_return(status: :passed, result: '5')
  end

  it 'can submit and run query' do
    results = exercise.submit_query!(user, query: 'foo', content: 'bar')
    expect(results[:status]).to eq Status::Passed
    expect(results[:result]).to eq '5'
  end

end
