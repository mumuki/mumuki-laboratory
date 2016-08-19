require 'spec_helper'

feature 'Choose organization Flow' do

  scenario 'when routes does not exist' do
    visit '/foo'

    expect(page).to have_text('You may have mistyped the address')
  end
end
