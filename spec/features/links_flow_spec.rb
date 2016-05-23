require 'spec_helper'

feature 'Lessons Flow' do
  let!(:lesson) { create(:lesson, name: 'L1') }
  let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

  let(:other_organization) { create(:organization, name: 'other') }
  let(:other_book) { create(:book) }
  let!(:other_lesson) { create(:lesson, name: 'L2') }
  let!(:other_chapter) { create(:chapter, name: 'C2', lessons: [other_lesson], book: other_book) }

  before { reindex_current_book! }
  before { reindex_book! other_organization }

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
end
