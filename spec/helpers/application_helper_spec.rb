require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper

  describe '#limit' do
    it { expect(limit([1, 2, 3, 4, 5, 6])).to eq [6, 5, 4, 3, 2] }
    it { expect(limit([1, 2, 3, 4, 5, 6], true)).to eq [2, 3, 4, 5, 6] }
    it { expect(limit([1, 2, 3], true)).to eq [1, 2, 3] }
  end

  describe '#language_image_tag' do
    let(:haskell_img_tag) { '<img alt="haskell" height="16" src="https://www.haskell.org/wikistatic/haskellwiki_logo.png" />' }
    it { expect(language_image_tag('haskell')).to eq haskell_img_tag }
  end

  it '#link_to_exercise'
  it '#link_to_guide'
  it '#link_to_github'
  it '#paginate'
end
