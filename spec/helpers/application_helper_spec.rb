require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell', image_url: 'https://foo/foo.png') }
    let(:haskell_img_tag) { '<img alt="Haskell" class="special-icon" height="16" src="https://foo/foo.png" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
  end

  describe '#link_to_exercise' do
    context 'when exercise has no guide' do
      let(:exercise) { create(:exercise, name: 'foo', id: 1) }
      it { expect(link_to_exercise(exercise)).to eq '<a href="/exercises/foo">foo</a>' }
    end
    context 'when exercise has guide' do
      let(:guide) { create(:guide, name: 'bar') }
      let(:exercise) { create(:exercise, name: 'foo', guide: guide, id: 1, position: 3) }

      it { expect(link_to_exercise(exercise)).to eq '<a href="/exercises/bar-3-foo">foo</a>' }
    end
  end

  describe '#link_to_guide' do
    let(:guide) { create(:guide, name: 'foo', id: 1) }
    it { expect(link_to_guide(guide)).to start_with '<a href="/guides/foo">foo' }
  end

  describe '#link_to_github' do
    let(:guide) { create(:guide, github_repository: 'foo/bar') }
    it { expect(link_to_github(guide)).to eq '<a href="https://github.com/foo/bar">foo/bar</a>' }
  end

  describe '#status_icon' do
    let(:passed_submission) { create(:solution, status: :passed, expectation_results: []) }
    let(:failed_submission) { create(:solution, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check text-success special-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times text-danger special-icon"></i>' }
  end

end
