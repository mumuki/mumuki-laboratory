require 'spec_helper'

feature 'Read Exercise Flow' do
  let!(:chapter) {
    create(:chapter, lessons: [
        create(:lesson, exercises: [
            create(:exercise, tag_list: ['haskell'], name: 'Foo', description: 'an awesome problem description')])]) }

  let(:user) { User.find_by(name: 'testuser') }

  before { reindex_current_book! }

  scenario 'show exercise from search' do
    visit '/exercises'

    click_on 'Foo'

    expect(page).to have_text('an awesome problem description')
  end
end
