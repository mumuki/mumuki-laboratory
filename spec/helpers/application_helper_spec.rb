require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    context 'in path' do
      let(:exercise) { lesson.exercises.first }
      let(:lesson) {
        create(:lesson, name: 'A Guide', exercises: [
            create(:exercise, name: 'An Exercise')]) }
      let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

      before { reindex_current_organization! }

      it { expect(page_title nil).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title Problem.new).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title exercise).to eq 'C1: A Guide - An Exercise - Mumuki' }
    end
  end

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell') }
    let(:haskell_img_tag) { '<span alt="Haskell" class="fa da da-haskell lang-icon" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
  end

  describe '#link_to_exercise' do
    let(:exercise) { lesson.exercises.third }
    let(:lesson) {
      create(:lesson, name: 'bar', exercises: [
          create(:exercise, name: 'foo2', id: 10),
          create(:exercise, name: 'foo2', id: 20),
          create(:exercise, name: 'foo3', id: 30)
      ]) }
    let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

    before { reindex_current_organization! }

    it { expect(link_to_path_element(exercise, mode: :plain)).to eq '<a href="/exercises/30-c1-bar-foo3">foo3</a>' }
    it { expect(link_to_path_element(exercise, mode: :friendly)).to eq '<a href="/exercises/30-c1-bar-foo3">C1: bar - foo3</a>' }
    it { expect(link_to_path_element(exercise)).to eq '<a href="/exercises/30-c1-bar-foo3">3. foo3</a>' }
  end

  describe '#link_to_guide' do
    let(:lesson) { create(:lesson, id: 1, name: 'foo') }
    it { expect(link_to_path_element(lesson)).to start_with '<a href="/lessons/1-foo">foo' }
  end

  describe '#status_icon' do
    let(:passed_submission) { create(:assignment, status: :passed, expectation_results: []) }
    let(:failed_submission) { create(:assignment, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check-circle text-success status-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times-circle text-danger status-icon"></i>' }
  end

end
