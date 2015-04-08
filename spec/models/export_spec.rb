require 'spec_helper'

describe Export do
  let(:guide) { create(:guide, ) }
  let!(:exercise_1) { create(:exercise, guide: guide, title: 'foo') }
  let!(:exercise_2) { create(:exercise, guide: guide, title: 'bar') }

  it { guide.exports.create! }

end
