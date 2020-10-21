require 'spec_helper'

feature 'Guides Flow', organization_workspace: :test do
  let(:haskell) { create(:haskell) }
  let!(:exercises) { [
    create(:exercise, name: 'Foo', guide: guide, number: 1, description: 'Description of foo'),
    create(:exercise, name: 'Bar', guide: guide, number: 2),
    create(:exercise, name: 'Baz', guide: guide, number: 4)
  ] }
  let(:guide) { create(:guide, name: 'awesomeGuide', description: 'An awesome guide', language: haskell, slug: 'foo/bar', authors: authors) }
  let(:authors) { nil }
  let(:guide_not_in_path) { create(:guide) }

  let!(:lesson) { create(:lesson, guide: guide) }
  let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }


  let!(:complement) { create(:complement, name: 'a complement', exercises: [
    create(:exercise, name: 'complementary exercise 1'),
    create(:exercise, name: 'complementary exercise 2')
  ]) }

  before { reindex_current_organization! }

  let(:user) { create(:user) }


  context 'inexistent guide' do
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
  end

  context 'existent guide' do
    context 'no authors' do
      let(:authors) { '' }

      scenario 'visit complement by guide by id' do
        visit "/guides/#{complement.guide.id}"

        expect(page).to have_text('a complement')
        expect(page).to have_text('Exercises')
      end

      scenario 'visit lesson by id' do
        visit "/guides/#{lesson.guide.id}"

        expect(page).to have_text('awesomeGuide')
        expect(page).to have_text('Exercises')
        expect(page).to_not have_text('Creative Commons')
      end


      scenario 'visit guide by slug' do
        visit '/guides/foo/bar'

        expect(page).to have_text('awesomeGuide')
        expect(page).to have_text('An awesome guide')
        expect(page).to have_text('Exercises')
      end
    end

    context 'with authors' do
      let(:authors) { 'Jon Doe' }

      scenario 'visit lesson by id' do
        visit "/guides/#{lesson.guide.id}"

        expect(page).to have_text('awesomeGuide')
        expect(page).to have_text('Exercises')
        expect(page).to have_text('Jon Doe')
        expect(page).to have_text('Creative Commons')
      end


      scenario 'visit lesson, then exercise' do
        visit "/guides/#{lesson.guide.id}"
        click_on 'Foo'

        expect(page).to have_text('Description of foo')
        expect(page).to have_text('Jon Doe')
        expect(page).to have_text('Creative Commons')
      end
    end

    context 'not logged user' do
      scenario 'should not see the edit guide link' do
        visit "/guides/#{lesson.guide.id}"
        expect(page).not_to have_xpath("//a[@title='Edit']")
      end
    end

    context 'logged user' do
      before { set_current_user! user }
      let(:writer) { create(:user, permissions: {student: 'private/*', writer: 'private/*'}) }

      scenario 'with no permissions should not see the edit guide link' do
        visit "/guides/#{lesson.guide.id}"
        expect(page).not_to have_xpath("//a[@title='Edit']")
      end

      scenario 'writer should see the edit guide link', :xpath_no_matches do
        set_current_user! writer

        visit "/guides/#{lesson.guide.id}"
        expect(page).to have_xpath("//a[@title='Edit']")
      end
    end
  end
end
