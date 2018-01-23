require 'spec_helper'

feature 'Choose organization Flow' do

  let(:user) { create(:user, permissions: {student: ''}) }
  let(:user2) { create(:user, permissions: {student: 'pdep/*'}) }
  let(:user3) { create(:user, permissions: {student: 'pdep/*:foo/*'}) }

  before do
    %w(pdep central foo).each do |it|
      create(:organization,
             name: it,
             book: create(:book,
                          chapters: [create(:chapter, lessons: [create(:lesson)])],
                          name: it,
                          slug: "mumuki/mumuki-the-#{it}-book"))
    end
  end

  before { Organization.central.switch! }
  before { set_current_user! user }

  scenario 'when visiting with implicit subdomain and no permissions' do
    set_implicit_central!

    visit '/'

    expect(page).to have_text('Sign Out')
    expect(page).not_to have_text('Do you want to go there?')
  end

  scenario 'when visiting with implicit subdomain and permissions to only one organization' do
    set_current_user! user2
    set_implicit_central!

    visit '/'

    expect(page).to have_text('Sign Out')
    expect(page).to have_text('pdep')
    expect(page).not_to have_text('Do you want to go there?')
  end

  scenario 'when visiting with implicit subdomain and permissions to two or more organizations' do
    set_current_user! user3
    set_implicit_central!

    visit '/'

    expect(page).to have_text('Sign Out')
    expect(page).to have_text('Do you want to go there?')
  end

  scenario 'when visiting central explicitly' do
    set_subdomain_host!('central')

    visit '/'

    expect(page).not_to have_text('Do you want to go there?')
    expect(page).not_to have_text('pdep')
  end

  scenario 'when visit foo subdomain' do
    set_current_user! user3
    set_subdomain_host!('foo')

    visit '/'

    expect(page).not_to have_text('Do you want to go there?')
    expect(page).to have_text('foo')
  end

end
