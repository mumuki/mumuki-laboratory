require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper LinksHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    context 'in path' do
      let(:exercise) { build(:exercise, name: 'An Exercise') }

      let!(:unit) {
        create(:unit, organization: Organization.current, book:
          build(:book, name: 'B1', chapters: [
            build(:chapter, name: 'C1', lessons: [
              build(:lesson, name: 'A Guide', exercises: [exercise])
            ])
          ]))}

      before { reindex_current_organization! }

      it { expect(page_title nil).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title Problem.new).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title exercise).to eq 'C1 - A Guide - An Exercise - Mumuki' }
    end
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
    it { expect(link_to_path_element(exercise, mode: :friendly)).to eq '<a href="/exercises/30-c1-bar-foo3">C1 - bar - foo3</a>' }
    it { expect(link_to_path_element(exercise)).to eq '<a href="/exercises/30-c1-bar-foo3">3. foo3</a>' }
  end

  describe '#link_to_guide' do
    let(:lesson) { create(:lesson, id: 1, name: 'foo', number: 2) }
    it { expect(link_to_path_element(lesson, mode: :plain)).to start_with '<a href="/lessons/1-foo">foo' }
    it { expect(link_to_path_element(lesson)).to start_with '<a href="/lessons/1-foo">2. foo' }
  end

end
