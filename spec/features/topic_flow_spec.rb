require 'spec_helper'

feature 'Topic Flow', organization_workspace: :test do
  let(:user) { create(:user) }
  let(:problem) { build(:problem) }
  let(:chapter) { create(:chapter, name: 'Functional Programming', lessons: [ create(:lesson, exercises: [ problem ]) ]) }

  let!(:topic_in_path) { chapter.topic }
  let(:topic_not_in_path) { create(:topic, name: 'Logic Programming') }

  before { reindex_current_organization! }
  before { set_current_user! user }

  scenario 'visit topic in path transparently' do
    visit "/topics/#{topic_in_path.transparent_id}"

    expect(page).to have_text('Functional Programming')
  end

  scenario 'visit topic in path not transparently' do
    visit "/topics/#{topic_not_in_path.transparent_id}"

    expect(page).to_not have_text('Logic Programming')
    expect(page).to_not have_text('Content Programming')
  end
end
