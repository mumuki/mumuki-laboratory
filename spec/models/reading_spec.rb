require 'spec_helper'

describe Reading do
  let!(:reading) { create(:reading) }
  let!(:user) { create(:user) }

  before { @assignment = reading.submit_confirmation!(user) }

  it { expect(@assignment.status).to eq Status::Passed }
end
