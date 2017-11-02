require 'spec_helper'

feature 'Complements Flow' do
  let(:complement_not_in_path) { create(:complement) }

  before { reindex_current_organization! }

  let(:user) { User.find_by(name: 'testuser') }

  context 'inexistent complement' do
    scenario 'visit complement by id, unknown complement' do
      visit '/complements/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end
end
