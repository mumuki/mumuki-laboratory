require 'spec_helper'

feature 'Certifications flow', organization_workspace: :test do

  let(:user) { create :user, first_name: 'Foo', last_name: 'Bar' }

  before { set_current_user! user }

  before { Organization.find_by_name('test').switch! }
  before { create :certificate, user: user, code: 'abc' }

  before { visit '/certificates/verify/abc' }

  scenario { expect(page).to have_text('Foo Bar') }
  scenario { expect(page).to have_link(href: /linkedin\.com\/profile\/add/) }
  scenario { expect(page).to have_link(href: /certificates\/download\/abc/) }
end
