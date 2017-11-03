require 'spec_helper'

describe 'Navigation' do
  let(:organization_1) { create(:organization, name: 'org 1', units: [unit_1]) }
  let(:organization_2) { create(:organization, name: 'org 2', units: [unit_2]) }

  let(:unit_1) do
    build(:unit, book: book_1, complements: [build(:complement)])
  end

  let(:unit_2) do
    build(:unit, book: book_2, complements: [build(:complement)])
  end

  let(:book_1) do
    create(:book,
           chapters: [
               create(:chapter, lessons: [
                   create(:lesson, exercises: [
                       create(:exercise)
                   ]),
                   create(:lesson)
               ])
           ])
  end

  let(:book_2) do
    create(:book,
           chapters: [
               create(:chapter, lessons: [
                   create(:lesson, exercises: [
                       create(:exercise)
                   ]),
                   create(:lesson)
               ])
           ])
  end

  let(:chapter_1) { book_1.chapters.first }
  let(:chapter_2) { book_2.chapters.first }

  let(:lesson_1) { chapter_1.lessons.first }
  let(:lesson_2) { chapter_2.lessons.first }

  let(:exercise_1) { lesson_1.exercises.first }
  let(:exercise_2) { lesson_2.exercises.first }

  before { reindex_organization! organization_1 }
  before { reindex_organization! organization_2 }

  it { expect(unit_1.complements.first.used_in? Organization.current).to be false }
  it { expect(unit_1.complements.first.used_in? organization_1).to be true }
  it { expect(unit_1.complements.first.used_in? organization_2).to be false }

  it { expect(unit_2.complements.first.used_in? Organization.current).to be false }
  it { expect(unit_2.complements.first.used_in? organization_1).to be false }
  it { expect(unit_2.complements.first.used_in? organization_2).to be true }

  it { expect(chapter_1.used_in? organization_1).to be true }
  it { expect(chapter_1.used_in? organization_2).to be false }

  it { expect(chapter_2.used_in? organization_1).to be false }
  it { expect(chapter_2.used_in? organization_2).to be true }

  it { expect(lesson_1.used_in? organization_1).to be true }
  it { expect(lesson_1.used_in? organization_2).to be false }

  it { expect(lesson_2.used_in? organization_1).to be false }
  it { expect(lesson_2.used_in? organization_2).to be true }

  it { expect(exercise_1.used_in? organization_1).to be true }
  it { expect(exercise_1.used_in? organization_2).to be false }

  it { expect(exercise_2.used_in? organization_1).to be false }
  it { expect(exercise_2.used_in? organization_2).to be true }
end
