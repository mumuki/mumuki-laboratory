require 'spec_helper'

describe 'no-units organization events' do
  before { create :book, slug: 'a-book', id: 8 }

  let(:organization) { Organization.find_by(name: 'test-orga') }
  let(:organization_json) { {
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
    id: 998} }

  shared_examples 'a task that persists an organization' do
    it { expect(organization.name).to eq 'test-orga' }
    it { expect(organization.first_book.id).to eq 8 }
    it { expect(organization.profile.description).to eq 'Academy' }
    it { expect(organization.settings.public?).to be false }
    it { expect(organization.theme.theme_stylesheet_url).to eq 'http://mumuki.io/theme.css' }
  end

  describe Organization do
    before { create :organization, name: 'test-orga', id: 55 }

    context 'when a message is received' do
      before { Organization.import_from_json! organization_json }

      it { expect(organization.id).to eq 55 }
      it_behaves_like 'a task that persists an organization'
    end
  end

  describe Organization do
    context 'when a message is received' do
      before { Organization.import_from_json! organization_json }

      it { expect(organization.id).not_to eq 998 }
      it_behaves_like 'a task that persists an organization'
    end
  end
end


describe 'with units organization events' do
  before { create :book, slug: 'a-book', id: 8 }
  before { create :book, slug: 'another-book', id: 9 }

  before { create :complement, slug: 'a-complement' }
  before { create :project, slug: 'a-project' }

  let(:organization) { Organization.find_by(name: 'test-orga') }
  let(:organization_json) { {
    name: 'test-orga',
    contact_email: 'issues@mumuki.io',
    units: [{
        book: 'a-book',
        projects: [],
        complements: [],
      },
      {
        book: 'another-book',
        projects: ['a-project'],
        complements: ['a-complement']
      }],
    locale: 'en',
    public: false,
    description: 'Academy',
    login_methods: %w{facebook twitter google},
    logo_url: 'http://mumuki.io/logo-alt-large.png',
    terms_of_service: 'TOS',
    theme_stylesheet_url: 'http://mumuki.io/theme.css',
    extension_javascript_url: 'http://mumuki.io/scripts.js',
    id: 998} }

  shared_examples 'a task that persists an organization' do
    it { expect(organization.name).to eq 'test-orga' }
    it { expect(organization.units.size).to eq 2 }

    it { expect(organization.first_book.id).to eq 8 }
    it { expect(organization.first_unit.projects).to be_empty }
    it { expect(organization.first_unit.complements).to be_empty }

    it { expect(organization.units.second.book.id).to eq 9 }
    it { expect(organization.units.second.projects.size).to be 1 }
    it { expect(organization.units.second.complements.size).to be 1 }
  end

  describe Organization do
    before { create :organization, name: 'test-orga', id: 55 }

    context 'when a message is received' do
      before { Organization.import_from_json! organization_json }

      it { expect(organization.id).to eq 55 }
      it_behaves_like 'a task that persists an organization'
    end
  end

  describe Organization do
    context 'when a message is received' do
      before { Organization.import_from_json! organization_json }

      it { expect(organization.id).not_to eq 998 }
      it_behaves_like 'a task that persists an organization'
    end
  end
end
