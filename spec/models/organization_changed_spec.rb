require 'spec_helper'

describe Office::Event::OrganizationChanged do
  before { create :book, slug: 'a-book', id: 8 }
  before { create :organization, name: 'test-orga', id: 2 }

  let(:organization) { Organization.find_by(name: 'test-orga') }
  let(:organization_json) {
    {organization: {
      name: 'test-orga',
      contact_email: 'issues@mumuki.io',
      books: ['a-book'],
      locale: 'en',
      public: false,
      description: 'Academy',
      login_methods: %w{facebook twitter google},
      logo_url: 'http://mumuki.io/logo-alt-large.png',
      terms_of_service: 'TOS',
      theme_stylesheet_url: 'http://mumuki.io/theme.css',
      extension_javascript_url: 'http://mumuki.io/scripts.js',
      id: 998
    }}
  }

  context 'when the message is received' do
    before { Office::Event::OrganizationChanged.execute! organization_json }

    it { expect(organization.id).to eq 2 }
    it { expect(organization.name).to eq 'test-orga' }
    it { expect(organization.contact_email).to eq 'issues@mumuki.io' }
    it { expect(organization.book_id).to eq 8 }
    it { expect(organization.book_ids).to eq [8] }
    it { expect(organization.locale).to eq 'en' }
    it { expect(organization.public).to eq false }
    it { expect(organization.description).to eq 'Academy' }
    it { expect(organization.login_methods).to eq %w{facebook twitter google} }
    it { expect(organization.logo_url).to eq 'http://mumuki.io/logo-alt-large.png' }
    it { expect(organization.terms_of_service).to eq 'TOS' }
    it { expect(organization.theme_stylesheet_url).to eq 'http://mumuki.io/theme.css' }
    it { expect(organization.extension_javascript_url).to eq 'http://mumuki.io/scripts.js' }
  end
end
