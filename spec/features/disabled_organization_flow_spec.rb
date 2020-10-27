require 'spec_helper'

feature 'disable user flow', organization_workspace: :test do
  let!(:current_organization) { Organization.current }
  let(:user) { create(:user) }

  let!(:chapter) {
    create(:chapter, lessons: [
        create(:lesson, guide: create(:guide))]) }

  let(:book) { current_organization.book }

  before { reindex_current_organization! }

  before { set_current_user! user }

  scenario 'enabled organization' do
    visit '/'

    expect(page).to have_text(current_organization.book.name)
    expect(user.reload.last_organization).to eq current_organization
  end

  context 'unprepared organization' do

    before { current_organization.update! in_preparation_until: 2.minutes.since }

    scenario 'visit /' do
      visit '/'

      expect(page).to_not have_text(current_organization.book.name)
      expect(page).to have_text(I18n.t(:unprepared_organization_explanation))
    end

    scenario 'visit /user' do
      visit '/test/user'

      expect(page).to_not have_text(current_organization.book.name)
      expect(page).to have_text(I18n.t(:unprepared_organization_explanation))
    end

  end

  context 'disabled organization' do

    before { current_organization.update! disabled_from: 2.minutes.ago }

    scenario 'visit /' do
      visit '/'

      expect(page).to_not have_text(current_organization.book.name)
      expect(page).to have_text(I18n.t(:disabled_organization_explanation))
    end

    scenario 'visit /user' do
      visit '/test/user'

      expect(page).to_not have_text(current_organization.book.name)
      expect(page).to have_text(I18n.t(:disabled_organization_explanation))
    end

    end
end

