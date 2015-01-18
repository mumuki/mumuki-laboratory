require 'spec_helper'

feature 'Read Exercise Flow' do
  let!(:exercise) { create(:exercise, tag_list: ['haskell'], title: 'Foo', description: 'an awesome problem description') }

  scenario 'show exercise from search' do
    visit '/en/search'

    click_on 'Foo'
    expect(page).to have_text('an awesome problem description')
  end
end
