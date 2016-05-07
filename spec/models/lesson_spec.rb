require 'spec_helper'

describe Lesson do
  let(:user) { create(:user) }
  describe '#friendly' do
    let!(:chapter) {
      create(:chapter, lessons: [
          create(:lesson),
          create(:lesson)
      ]) }

    let(:lesson) { chapter.lessons.second }

    before { reindex_current_book! }

    it { expect(lesson.friendly).to eq "#{chapter.name}: #{lesson.name}" }
  end

  describe '#friendly_name' do
    let!(:chapter) {
      create(:chapter, name: 'Fundamentos De Programación', lessons: [
          create(:lesson),
          create(:lesson),
          create(:lesson, name: 'una guía')
      ]) }
    let(:lesson) { chapter.lessons.third }

    before { reindex_current_book! }

    it { expect(lesson.friendly_name).to eq "#{lesson.id}-fundamentos-de-programacion-una-guia" }
  end

  describe '#navigable_name' do
    let!(:chapter) {
      create(:chapter, lessons: [
          create(:lesson),
          create(:lesson)
      ]) }
    let(:lesson) { chapter.lessons.second }

    before { reindex_current_book! }

    it { expect(lesson.navigable_name).to eq "2. #{lesson.name}" }
  end

  describe '#next_for' do
    context 'when it is single' do
      let!(:chapter) { create(:chapter, lessons: [
          create(:lesson),
          create(:lesson)
      ]) }
      let(:lesson) { chapter.lessons.second }

      before { reindex_current_book! }

      it { expect(lesson.next(user)).to be nil }
    end

    context 'when there is a next guide' do
      let!(:chapter) { create(:chapter, lessons: [
          create(:lesson),
          create(:lesson),
          create(:lesson)
      ]) }
      let(:lesson) { chapter.lessons.second }
      let(:other_lesson) { chapter.lessons.third }

      before { reindex_current_book! }

      it { expect(lesson.next(user)).to eq other_lesson }
    end
    context 'when there are many next guides at same level' do
      let!(:chapter) {
        create(:chapter, lessons: [
            create(:lesson),
            create(:lesson),
            create(:lesson),
            create(:lesson),
        ]) }

      let(:lesson) { chapter.lessons.first }
      let!(:other_lesson_1) { chapter.lessons.second }
      let!(:other_lesson_2) { chapter.lessons.third }

      before { reindex_current_book! }

      it { expect(lesson.next(user)).to eq other_lesson_1 }
    end
  end
end