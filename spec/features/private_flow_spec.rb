require 'spec_helper'

feature 'When public org' do
  scenario 'should access normally' do
    visit '/exercises'

    expect(page).to have_text('Nobody created an exercise for this search yet')
  end
end

feature 'When private org' do
  before {
    create(:organization,
         name: 'private',
         private: true,
         book: create(:book, name: 'private', slug: 'mumuki/mumuki-the-private-book'))
    set_subdomain_host 'private'
  }

  scenario 'should not access' do
    visit '/guides'


    expect(page).not_to have_text('Nobody created a guide for this search yet')
  end

  scenario 'should raise routing error' do
    expect_any_instance_of(ApplicationController).to receive(:must_login).and_return(false)
    expect_any_instance_of(ApplicationController).to receive(:from_auth0?).and_return(false)
    expect_any_instance_of(ApplicationController).to receive(:can_visit?).and_return(false)

    expect { visit '/guides' }.to raise_error(ActionController::RoutingError)
  end
end
