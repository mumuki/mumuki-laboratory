require 'spec_helper'

feature 'Terms Flow', organization_workspace: :test do
  let(:forum_terms_scopes) { Term::FORUM_RELATED }
  let(:general_terms_scopes) { Term::GENERAL }
  let(:role_terms_scopes) { Term::ROLE_SPECIFIC }

  let(:all_terms_scopes) { forum_terms_scopes + general_terms_scopes + role_terms_scopes }
  let!(:terms) { all_terms_scopes.map { |it| create(:term, scope: it, locale: Organization.current.locale) } }

  let(:test_organization) { Organization.locate!("test") }

  let(:expected_terms) { [] }
  let(:unexpected_terms) { all_terms_scopes - expected_terms }

  shared_context 'has expected terms' do
    scenario 'with expected terms' do
      visit terms_path

      expected_terms.each do |it|
        expect(page).to have_text(Term.find_by(scope: it).content)
      end

      unexpected_terms.each do |it|
        expect(page).not_to have_text(Term.find_by(scope: it).content)
      end
    end
  end

  context 'with student logged in' do
    let(:student) { create(:user, uid: 'test@mumuki.org', permissions: {student: 'test/*'}) }

    before { set_current_user! student }

    describe 'visit user terms path' do
      let(:terms_path) { '/user/terms' }
      let(:expected_terms) { general_terms_scopes }

      it_behaves_like 'has expected terms'
    end

    context 'visit forum' do
      let(:terms_path) { '/discussions/terms' }

      context 'with disabled forum' do

        it_behaves_like 'has expected terms'
      end

      context 'with enabled forum' do
        let(:expected_terms) { forum_terms_scopes }
        before { test_organization.update! forum_enabled: true }

        it_behaves_like 'has expected terms'
      end
    end
  end

  context 'with janitor logged in' do
    let(:janitor) { create(:user, uid: 'test@mumuki.org', permissions: {student: 'test/*', janitor: 'other/*'}) }

    before { set_current_user! janitor }

    describe 'visit user terms path' do
      let(:terms_path) { '/user/terms' }
      let(:expected_terms) { general_terms_scopes + [:janitor] }

      it_behaves_like 'has expected terms'
    end

    context 'visit forum' do
      let(:terms_path) { '/discussions/terms' }

      context 'with disabled forum' do
        it_behaves_like 'has expected terms'
      end

      context 'with enabled forum' do
        let(:expected_terms) { forum_terms_scopes }
        before { test_organization.update! forum_enabled: true }

        it_behaves_like 'has expected terms'
      end
    end
  end
end

