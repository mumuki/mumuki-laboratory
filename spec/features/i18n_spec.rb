require 'spec_helper'

feature 'Localized Pages' do
  scenario 'search from home, in spanish' do
    visit '/?locale=es'

    expect(page).to have_link('Empezá a practicar!', href: '/categories?locale=es')

    visit '/guides?locale=es'
    expect(page).to have_text('Nadie creó una guía para tu búsqueda aún')
  end
end
