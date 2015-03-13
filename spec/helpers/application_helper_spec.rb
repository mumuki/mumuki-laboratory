require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  describe '#limit' do
    it { expect(limit([1, 2, 3, 4, 5, 6])).to eq [6, 5, 4, 3, 2] }
    it { expect(limit([1, 2, 3, 4, 5, 6], true)).to eq [2, 3, 4, 5, 6] }
    it { expect(limit([1, 2, 3], true)).to eq [1, 2, 3] }
  end

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell', image_url: 'https://foo/foo.png') }
    let(:haskell_img_tag) { '<img alt="Haskell" class="special-icon has-tooltip" height="16" src="https://foo/foo.png" title="Haskell" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
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

  describe '#status_icon' do
    let(:passed_submission) { create(:submission, status: :passed) }
    let(:failed_submission) { create(:submission, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check text-success special-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times text-danger special-icon"></i>' }
  end

end
