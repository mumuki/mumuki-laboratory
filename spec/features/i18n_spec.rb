require 'spec_helper'

feature 'Localized Pages' do
  scenario 'search from home, in spanish' do
    visit '/es/'

    expect(page).to have_link('Empezá a practicar!', href: '/es/exercises')

    visit '/es/exercises'
    expect(page).to have_text('Nadie creó un ejercicio para tu búsqueda aún')
  end
end
