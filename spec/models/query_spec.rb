require 'spec_helper'

describe Query do
  let!(:exercise) { create(:exercise) }

  before do
    allow_any_instance_of(Language).to receive(:run_query!).and_return(status: :passed, result: '5')
  end

  it "can submit and run query" do
    query = exercise.submit_query!(query: 'foo', content: 'bar')
    query.run!
    expect(query.status).to eq Status::Passed
    expect(query.result).to eq '5'
  end

end
