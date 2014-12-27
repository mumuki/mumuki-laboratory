require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper

  describe '#limit' do
    it { expect(limit([1, 2, 3, 4, 5, 6])).to eq [6, 5, 4, 3, 2] }
    it { expect(limit([1, 2, 3, 4, 5, 6], true)).to eq [2, 3, 4, 5, 6] }
    it { expect(limit([1, 2, 3], true)).to eq [1, 2, 3] }
  end

  it '#link_to_exercise'
  it '#link_to_guide'
  it '#link_to_github'
  it '#language_image_url'
  it '#paginate'
end
