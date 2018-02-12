require 'spec_helper'

feature 'custom domain' do
  let(:custom_domain) {'labodomain.com'}
  let!(:organization) {create(:public_organization,
                              name: 'custom',
                              settings: {laboratory_custom_domain: custom_domain},
                              book: create(:book, name: 'custom', slug: 'mumuki/mumuki-custom-the-book')) }

  let!(:exercise) { build(:exercise) }
  let(:guide) { create(:guide) }
  let(:exam) { create(:exam) }
  let!(:chapter) {
    create(:chapter, lessons: [
      create(:lesson, guide: guide)]) }

  before { organization.book.chapters = [chapter] }
  before { reindex_organization! organization }

  context 'with custom domain' do
    scenario 'existing organization' do
      Capybara.app_host = "http://#{custom_domain}"

      visit '/'

      expect(page).to have_text('ム mumuki')
      expect(page).to have_text(organization.book.name)
    end
  end
end
