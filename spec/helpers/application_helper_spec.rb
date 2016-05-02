require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    let(:lesson) {
      create(:lesson, name: 'A Guide', exercises: [
          create(:exercise, name: 'An Exercise')]) }
    let(:exercise) { lesson.exercises.first }

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
      let(:lesson) {
        create(:lesson, name: 'bar', exercises: [
            create(:exercise, name: 'foo2', id: 10),
            create(:exercise, name: 'foo2', id: 20),
            create(:exercise, name: 'foo3', id: 30)
        ]) }
      let(:exercise) { lesson.exercises.third }

      it { expect(link_to_path_element(exercise, mode: :plain)).to eq '<a href="/exercises/30-bar-foo3">foo3</a>' }
      it { expect(link_to_path_element(exercise, mode: :friendly)).to eq '<a href="/exercises/30-bar-foo3">bar - foo3</a>' }
      it { expect(link_to_path_element(exercise)).to eq '<a href="/exercises/30-bar-foo3">3. foo3</a>' }
    end
  end

  describe '#link_to_guide' do
    let(:lesson) { create(:lesson, guide: create(:guide, name: 'foo', id: 1)) }
    it { expect(link_to_path_element(lesson)).to start_with '<a href="/guides/1-foo">foo' }
  end

  describe '#status_icon' do
    let(:passed_submission) { create(:assignment, status: :passed, expectation_results: []) }
    let(:failed_submission) { create(:assignment, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check text-success status-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times text-danger status-icon"></i>' }
  end

end
