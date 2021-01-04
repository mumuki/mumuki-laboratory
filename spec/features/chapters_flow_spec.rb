require 'spec_helper'

feature 'Chapters flow', organization_workspace: :test do
  let(:haskell) { create(:haskell) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: lessons) }

  let(:lessons) { [lesson_1, lesson_2] }

  let(:lesson_1) {
    create(:lesson, name: 'Values and Functions', language: haskell, description: 'Values are everywhere...', exercises: [
      create(:exercise, name: 'The Basic Values', description: "Let's say we want to declare a variable...")
    ])
  }

  let(:lesson_2) {
    create(:lesson, name: 'Monads and Functors', language: haskell, description: 'Monds are everywhere too...', exercises: [
      create(:exercise, name: 'The Maybe Functor', description: "Let's say we want to model absense of value...")
    ])
  }

  before { reindex_current_organization! }

  context 'multilesson' do
    context 'no appendix' do
      scenario 'show chapter, no appendix' do
        visit "/chapters/#{chapter.id}"

        expect(page).to have_text('Functional Programming')
        expect(page).to have_text('The Basic Values')

        expect(page).to have_text('Monads and Functors')
        expect(page).to have_text('The Maybe Functor')

        expect(page).to_not have_text('Appendix')
        expect(page).to have_text('Lessons')
      end
    end

    context 'with appendix' do
      before { chapter.topic.update appendix: 'Check this article about endofunctors' }

      scenario 'show chapter, with appendix' do
        visit "/chapters/#{chapter.id}"

        expect(page).to have_text('Functional Programming')
        expect(page).to have_text('The Basic Values')

        expect(page).to have_text('Monads and Functors')
        expect(page).to have_text('The Maybe Functor')

        expect(page).to have_text('Appendix')
        expect(page).to have_text('Lessons')
      end

      scenario 'show appendix' do
        visit "/chapters/#{chapter.id}/appendix"
        expect(page).to have_text('Appendix')
        expect(page).to have_text('endofunctors')
      end
    end
  end

  context 'monolesson' do
    let(:lessons) { [lesson_1] }

    context 'with appendix' do
      before { chapter.topic.update appendix: 'Check this article about endofunctors' }

      scenario 'show chapter, with appendix' do
        visit "/chapters/#{chapter.id}"

        expect(page).to have_text('Functional Programming')
        expect(page).to have_text('The Basic Values')

        expect(page).to have_text('Appendix')
        expect(page).not_to have_text('Lessons')
      end

      scenario 'show appendix' do
        visit "/chapters/#{chapter.id}/appendix"
        expect(page).to have_text('Appendix')
        expect(page).to have_text('endofunctors')
      end
    end

  end

  context 'incognito user' do
    before { Organization.current.update! incognito_mode_enabled: true }
    scenario 'show chapter, no appendix' do
      visit "/chapters/#{chapter.id}"

      expect(page).to have_text('Functional Programming')
      expect(page).to have_text('The Basic Values')

      expect(page).to have_text('Monads and Functors')
      expect(page).to have_text('The Maybe Functor')

      expect(page).to_not have_text('Appendix')

      expect(page).to have_text('Sign in')
    end
  end
end
