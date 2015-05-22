require 'spec_helper'

feature 'Import Flow' do
  let(:user) { User.first }
  let(:guide) { create(:guide, name: 'Foo', description: 'an awesome guide description', author: user) }

  scenario 'Display imports' do
    visit '/'

    click_on 'Sign in with Github'

    visit "/guides/#{guide.id}/imports"

    expect(page).to have_text('hook')
    expect(page).to have_text('Updates')
  end
end
