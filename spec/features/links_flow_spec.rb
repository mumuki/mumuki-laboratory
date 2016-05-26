require 'spec_helper'

feature 'Lessons Flow' do
  let(:exercise) { create(:exercise, name:  'E1') }
  let!(:complement) { create(:complement) }
  let!(:lesson) { create(:lesson, name: 'L1', exercises: [exercise]) }
  let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }


  let(:other_organization) { create(:organization, name: 'other') }
  let(:other_book) { create(:book) }
  let(:other_exercise) { create(:exercise) }
  let!(:other_complement) { create(:complement, book: other_book) }
  let!(:other_lesson) { create(:lesson, exercises: [other_exercise]) }
  let!(:other_chapter) { create(:chapter, lessons: [other_lesson], book: other_book) }

  before { reindex_current_organization! }
  before { reindex_organization! other_organization }

  scenario 'visit lesson in path' do
    visit "/lessons/#{lesson.id}"

    expect(page).to have_text('L1')
  end

  scenario 'visit lesson not in path' do
    expect { visit "/lessons/#{other_lesson.id}" }.to raise_error(ActionController::RoutingError)
  end

  scenario 'visit chapter in path' do
    visit "/chapters/#{chapter.id}"

    expect(page).to have_text('C1')
  end

  scenario 'visit chapter not in path' do
    expect { visit "/chapters/#{other_chapter.id}" }.to raise_error(ActionController::RoutingError)
  end

  scenario 'visit exercise in path' do
    visit "/exercises/#{exercise.id}"

    expect(page).to have_text('E1')
  end

  scenario 'visit exercise not in path' do
    expect { visit "/exercises/#{other_exercise.id}" }.to raise_error(ActionController::RoutingError)
  end

  scenario 'visit exercise in path' do
    visit "/complements/#{complement.id}"

    expect(page).to have_text(complement.name)
  end

  scenario 'visit exercise not in path' do
    expect { visit "/complements/#{other_complement.id}" }.to raise_error(ActionController::RoutingError)
  end
end
