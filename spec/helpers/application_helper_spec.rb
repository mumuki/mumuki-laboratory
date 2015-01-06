require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper

  describe '#limit' do
    it { expect(limit([1, 2, 3, 4, 5, 6])).to eq [6, 5, 4, 3, 2] }
    it { expect(limit([1, 2, 3, 4, 5, 6], true)).to eq [2, 3, 4, 5, 6] }
    it { expect(limit([1, 2, 3], true)).to eq [1, 2, 3] }
  end

  describe '#language_image_tag' do
    let(:haskell) { create(:language, name: 'Haskell', image_url: 'https://foo/foo.png') }
    let(:haskell_img_tag) { '<img alt="Haskell" height="16" src="https://foo/foo.png" />' }
    it { expect(language_image_tag(haskell)).to eq haskell_img_tag }
  end

  describe '#link_to_exercise' do
    let(:exercise) { create(:exercise, title: 'foo', id: 1) }
    it { expect(link_to_exercise(exercise)).to eq '<a href="/exercises/1">foo</a>' }
  end

  describe '#link_to_guide' do
    let(:guide) { create(:guide, name: 'foo', id: 1 ) }
    it { expect(link_to_guide(guide)).to eq '<a href="/guides/1">foo</a>' }
  end

  describe '#link_to_github' do
    let(:guide) { create(:guide, github_repository: 'foo/bar') }
    it { expect(link_to_github(guide)).to eq '<a href="https://github.com/foo/bar">foo/bar</a>' }
  end

  describe '#status_span' do
    it { expect(status_span(:passed)).to eq '<span class="glyphicon glyphicon-ok text-success"></span>' }
    it { expect(status_span(:failed)).to eq '<span class="glyphicon glyphicon-remove text-danger"></span>' }
  end

end
