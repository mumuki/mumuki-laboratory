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
    let(:exercise) { create(:exercise, title: 'foo', id: 1) }
    it { expect(link_to_exercise(exercise)).to eq '<a href="/exercises/1">foo</a>' }
  end

  describe '#link_to_guide' do
    let(:guide) { create(:guide, name: 'foo', id: 1) }
    it { expect(link_to_guide(guide)).to start_with '<a href="/guides/1">foo' }
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

  describe '#next_guides_box' do
    let(:path) { create(:path) }

    context 'when guide has no suggestions' do
      let(:guide) { create(:guide, position: 1, path: path) }
      it { expect(next_guides_box(guide)).to eq 'You have finished this path!' }
    end

    context 'when guide has one suggestion' do
      let!(:suggested_guide) { create(:guide, position: 2, path: path) }
      let(:guide) { create(:guide, position: 1, path: path) }

      it { expect(next_guides_box(guide)).to include "<a class=\"btn btn-success\" href=\"/guides/#{suggested_guide.id}\">Next Guide: #{suggested_guide.name}</a>" }
    end

    context 'when guide has many suggestions' do
      let!(:suggested_guide_1) { create(:guide, position: 2, path: path) }
      let!(:suggested_guide_2) { create(:guide, position: 2, path: path) }
      let(:guide) { create(:guide, position: 1, path: path) }

      it { expect(next_guides_box(guide)).to include "<a class=\"btn btn-success\" href=\"/guides/#{suggested_guide_1.id}\">Next Guide: #{suggested_guide_1.name}</a>" }
      it { expect(next_guides_box(guide)).to be_html_safe } end
  end

end
