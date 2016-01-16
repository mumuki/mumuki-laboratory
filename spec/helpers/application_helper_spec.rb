require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    let(:guide) { create(:guide, name: 'A Guide')}
    let(:exercise) { create(:exercise, name: 'An Exercise', guide: guide, position: 2) }

    it { expect(page_title nil).to eq 'Mumuki - Improve your programming skills' }
    it { expect(page_title Problem.new).to eq 'Mumuki - Improve your programming skills' }
    it { expect(page_title exercise).to eq 'A Guide - An Exercise - Mumuki' }
  end

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell', devicon: 'haskell') }
    let(:haskell_img_tag) { '<span alt="Haskell" class="fa devicons devicons-haskell lang-icon" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
  end

  describe '#link_to_exercise' do
    context 'when exercise has guide' do
      let(:guide) { create(:guide, name: 'bar') }
      let(:exercise) { create(:exercise, name: 'foo', guide: guide, id: 1, position: 3) }

      it { expect(link_to_exercise(exercise, plain: true)).to eq '<a href="/exercises/1-bar-foo">3. foo</a>' }
      it { expect(link_to_exercise(exercise)).to eq '<a href="/exercises/1-bar-foo">bar - foo</a>' }
    end
  end

  describe '#link_to_guide' do
    let(:guide) { create(:guide, name: 'foo', id: 1) }
    it { expect(link_to_guide(guide)).to start_with '<a href="/guides/1-foo">foo' }
  end

  describe '#status_icon' do
    let(:passed_submission) { create(:assignment, status: :passed, expectation_results: []) }
    let(:failed_submission) { create(:assignment, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check text-success status-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times text-danger status-icon"></i>' }
  end

end
