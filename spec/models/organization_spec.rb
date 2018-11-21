require 'spec_helper'

describe Organization, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:central) { create(:organization, name: 'central') }

  describe '.import_from_resource_h!' do
    let(:book) { create(:book) }
    let(:resource_h) { {
      name: 'zulema',
      book: book.slug,
      profile: { locale: 'es', contact_email: 'contact@email.com' }
    } }
    let!(:imported) { Organization.import_from_resource_h! resource_h }
    let(:found) { Organization.find_by(name: 'zulema').to_resource_h }

    it { expect(imported).to_not be nil }
    it { expect(found).to json_eq resource_h, except: [:theme, :settings]  }
  end

  describe '.current' do
    let(:organization) { Organization.find_by(name: 'test') }
    it { expect(organization).to_not be nil }
    it { expect(organization).to eq Organization.current }
  end

  describe 'defaults' do
    let(:fresh_organization) { create(:organization, name: 'bar') }

    context 'no base organization' do
      it { expect(fresh_organization.settings.customized_login_methods?).to be true }
      it { expect(fresh_organization.theme_stylesheet).to eq nil }
    end

    context 'with base organization' do
      before { create(:base, theme_stylesheet: '.foo { width: 100%; }') }

      it { expect(fresh_organization.settings.customized_login_methods?).to be true }
      it { expect(fresh_organization.theme_stylesheet).to eq '.foo { width: 100%; }' }
    end
  end

  describe '#notify_recent_assignments!' do
    it { expect { Organization.current.notify_recent_assignments! 1.minute.ago }.to_not raise_error }
  end

  describe 'restricter_login_methods?' do
    let(:private_organization) { create(:private_organization, name: 'digitaldojo') }
    let(:public_organization) { create(:public_organization, name: 'guolok') }

    it { expect(private_organization.settings.customized_login_methods?).to be true }
    it { expect(private_organization.private?).to be true }

    it { expect { private_organization.update! public: true }.to raise_error('Validation failed: A public organization can not restrict login methods') }

    it { expect(public_organization.settings.customized_login_methods?).to be false }
    it { expect(public_organization.private?).to be false }
  end

  describe '#notify_assignments_by!' do
    it { expect { Organization.current.notify_assignments_by! user }.to_not raise_error }
  end

  describe '#in_path?' do
    let(:organization) { Organization.current }
    let!(:chapter_in_path) { create(:chapter, lessons: [
      create(:lesson, exercises: [
        create(:exercise),
        create(:exercise)
      ]),
      create(:lesson)
    ]) }
    let(:topic_in_path) { chapter_in_path.lessons.first }
    let(:topic_in_path) { chapter_in_path.topic }
    let(:lesson_in_path) { chapter_in_path.lessons.first }
    let(:guide_in_path) { lesson_in_path.guide }
    let(:exercise_in_path) { lesson_in_path.exercises.first }

    let!(:orphan_exercise) { create(:exercise) }
    let!(:orphan_guide) { orphan_exercise.guide }

    before { reindex_current_organization! }

    it { expect(organization.in_path? orphan_guide).to be false }
    it { expect(organization.in_path? orphan_exercise).to be false }

    it { expect(organization.in_path? chapter_in_path).to be true }
    it { expect(organization.in_path? topic_in_path).to be true }
    it { expect(organization.in_path? lesson_in_path).to be true }
    it { expect(organization.in_path? guide_in_path).to be true }
  end


  describe 'login_settings' do
    let(:fresh_organization) { create(:organization, name: 'foo') }
    it { expect(fresh_organization.login_settings.login_methods).to eq Mumukit::Login::Settings.default_methods }
    it { expect(fresh_organization.login_settings.social_login_methods).to eq [] }
  end

  describe 'validations' do
    let(:book) { create :book }

    context 'is valid when all is ok' do
      let(:organization) { build :public_organization }
      it { expect(organization.valid?).to be true }
    end

    context 'is invalid when there are no books' do
      let(:organization) { build :public_organization, book: nil }
      it { expect(organization.valid?).to be false }
    end

    context 'is invalid when the locale isnt known' do
      let(:organization) { build :public_organization, locale: 'uk-DA' }
      it { expect(organization.valid?).to be false }
    end

    context 'has login method' do
      let(:organization) { build :public_organization, login_methods: ['github'] }
      it { expect(organization.has_login_method? 'github').to be true }
      it { expect(organization.has_login_method? 'google').to be false }
    end
  end
end
