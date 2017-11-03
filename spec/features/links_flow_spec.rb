require 'spec_helper'

feature 'Lessons Flow' do
  let(:exercise) { create(:exercise, name:  'E1') }
  let!(:complement) { create(:complement) }
  let!(:lesson) { create(:lesson, name: 'L1', exercises: [exercise]) }
  let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }


  let!(:other_organization) {
    create(:organization, name: 'other', units: [
      build(:unit, complements: [other_complement], book:
        build(:book, chapters: [other_chapter]))
    ])
  }

  let(:other_chapter) { build(:chapter, lessons: [other_lesson]) }
  let(:other_lesson) { build(:lesson, exercises: [other_exercise]) }
  let(:other_exercise) { build(:exercise) }
  let(:other_complement) { build(:complement) }

  before { reindex_current_organization! }
  before { reindex_organization! other_organization }

  scenario 'visit lesson in path' do
    visit "/lessons/#{lesson.id}"

    expect(page).to have_text('L1')
  end

  scenario 'visit lesson not in path' do
    visit "/lessons/#{other_lesson.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit chapter in path' do
    visit "/chapters/#{chapter.id}"

    expect(page).to have_text('C1')
  end

  scenario 'visit chapter not in path' do
    visit "/chapters/#{other_chapter.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit exercise in path' do
    visit "/exercises/#{exercise.id}"

    expect(page).to have_text('E1')
  end

  scenario 'visit exercise not in path' do
    visit "/exercises/#{other_exercise.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit exercise in path' do
    visit "/complements/#{complement.id}"

    expect(page).to have_text(complement.name)
  end

  scenario 'visit exercise not in path' do
    visit "/complements/#{other_complement.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end
end
