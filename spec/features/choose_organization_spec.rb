require 'spec_helper'

feature 'Choose organization Flow' do

  let(:user) { create(:user, permissions: {student: 'pdep/*'}) }
  let(:user2) { create(:user, permissions: {student: ''}) }

  let(:organization) { create(:organization, name: 'central', book: create(:book, name: 'central', slug: 'mumuki/mumuki-the-book')).switch! }
  before { create(:organization, name: 'pdep', book: create(:book, name: 'pdep', slug: 'mumuki/mumuki-the-pdep-book')) }
  before { create(:organization, name: 'central', book: create(:book, name: 'central', slug: 'mumuki/mumuki-the-central-book')).switch! }
  before { set_current_user! user }

  scenario 'when visit implicit central' do
    set_implicit_central!

    visit '/'

    expect(page).to have_text('Sign Out')
    expect(page).to have_text('Do you want to go there?')
    expect(page).to have_text('pdep')
  end

  scenario 'when visit explicit central' do
    set_subdomain_host!('central')

    visit '/'

    expect(page).not_to have_text('Do you want to go there?')
    expect(page).not_to have_text('pdep')
  end

  scenario 'when visit test subdomain' do
    visit '/'

    expect(page).not_to have_text('Do you want to go there?')
    expect(page).not_to have_text('pdep')
  end

  scenario 'when user does not have any permission' do
    set_current_user! user2
    set_implicit_central!
    visit '/'

    expect(page).not_to have_text('Do you want to go there?')
  end
end
