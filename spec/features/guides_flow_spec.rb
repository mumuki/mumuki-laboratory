require 'spec_helper'

feature 'Guides Flow' do
  let(:haskell) { create(:haskell) }
  let!(:exercises) {[
    create(:exercise, name: 'Foo',        guide: guide, number: 1, description: 'Description of foo'),
    create(:exercise, name: 'Bar',        guide: guide, number: 2),
    create(:exercise, name: 'Baz',        guide: guide, number: 4)
  ]}
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'An awesome guide', language: haskell, slug: 'foo/bar') }
  let(:guide_not_in_path) { create(:guide) }

  let!(:lesson) { create(:lesson, guide: guide) }
  let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }


  let!(:complement) { create(:complement, name: 'a complement', exercises: [
      create(:exercise, name: 'complementary exercise 1'),
      create(:exercise, name: 'complementary exercise 2')
  ]) }

  before { reindex_current_organization! }

  let(:user) { User.find_by(name:'testuser') }

  scenario 'visit complement by guide by id' do
    visit "/guides/#{complement.guide.id}"

    expect(page).to have_text('a complement')
    expect(page).to have_text('Content')
  end

  scenario 'visit lesson by guide by id' do
    visit "/guides/#{lesson.guide.id}"

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('Content')
  end


  scenario 'visit guide by slug' do
    visit '/guides/foo/bar'

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('An awesome guide')
    expect(page).to have_text('Content')
  end

  scenario 'visit guide by slug, not in path' do
    visit "/guides/#{guide_not_in_path.slug}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit guide by slug, unknown guide' do
    visit '/guides/goo/baz'
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit guide by id, not in path' do
    visit "/guides/#{guide_not_in_path.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit guide by id, unknown guide' do
    visit '/guides/900000'
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit guides from search page, and starts practicing' do
    visit '/guides'

    click_on 'awesomeGuide'

    expect(page).to have_text('awesomeGuide')
    expect(page).to have_text('An awesome guide')
    expect(page).to have_text('Content')

    click_on 'Start Practicing'

    expect(page).to have_text('Description of foo')
  end
end
