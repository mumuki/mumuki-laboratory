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

    scenario 'enabled visitor' do
      visit '/'

      expect(page_body).to have_text(current_organization.book.name)
      expect(user.reload.last_organization).to eq current_organization
    end

    scenario 'disable visitor' do
      user.disable!

      visit '/'

      expect(page_body).to_not have_text(current_organization.book.name)
      expect(page_body).to have_text('You are trying to visit a permamently disabled or deleted resource')
    end
end
