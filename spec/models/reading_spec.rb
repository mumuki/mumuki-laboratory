require 'spec_helper'

describe Reading do
  let!(:reading) { create(:reading) }
  let!(:user) { create(:user) }

  let!(:result) { reading.submit_confirmation!(user) }

  it { expect(result).to eq status: :passed, result: '' }
end
