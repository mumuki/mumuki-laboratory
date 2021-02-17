require 'spec_helper'

feature 'Terms Flow', organization_workspace: :test do
  let(:forum_terms_scopes) { Term::FORUM_RELATED }
  let(:general_terms_scopes) { Term::GENERAL }
  let(:role_terms_scopes) { Term::ROLE_SPECIFIC }

  let(:all_terms_scopes) { forum_terms_scopes + general_terms_scopes + role_terms_scopes }
  let!(:terms) { all_terms_scopes.map { |it| create(:term, scope: it, locale: Organization.current.locale) } }

  let(:test_organization) { Organization.locate!("test") }

  let!(:exercise) { create(:indexed_exercise) }
  let(:expected_terms) { [] }
  let(:unexpected_terms) { all_terms_scopes - expected_terms }

  let(:student) { create(:user, uid: 'user.student@mumuki.org', permissions: {student: 'test/*'}) }

  let(:janitor) { create(:user, uid: 'user.janitor@mumuki.org', permissions: {student: 'test/*', janitor: 'other/*'}) }

  before { reindex_current_organization! }

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
    before { set_current_user! janitor }

    describe 'visit user terms path' do
      let(:terms_path) { '/user/terms' }
      let(:expected_terms) { general_terms_scopes + %w(janitor) }

      it_behaves_like 'has expected terms'
    end

    context 'with accepted general terms' do
      before { janitor.accept_profile_terms! }

      context 'visit forum' do
        let(:terms_path) { '/discussions/terms' }

        context 'with enabled forum' do
          let(:expected_terms) { forum_terms_scopes }
          before { test_organization.update! forum_enabled: true }

          it_behaves_like 'has expected terms'
        end
      end

      scenario 'visit any other path' do
        visit '/'

        expect(page).to have_text('Start Practicing')
      end
    end

    context 'with unaccepted role terms' do

      context 'visit forum' do
        let(:terms_path) { '/discussions/terms' }
        before { test_organization.update! forum_enabled: true }

        scenario 'with enabled forum' do
          visit '/discussions'
          expect(page).to have_text('Accept terms')

          check :user_terms_of_service
          click_on 'Accept'
          expect(page).to have_text('Discussions')
        end
      end

      scenario 'visit any other path' do
        visit '/'
        expect(page).to have_text('Accept terms')

        check :user_terms_of_service
        click_on 'Accept'
        expect(page).to have_text(test_organization.book.name)
      end

      scenario 'visit user path' do
        visit '/user'

        expect(page).to have_text(janitor.first_name)
      end
    end
  end

  context 'without user logged in' do
    describe 'visit user terms path' do
      let(:terms_path) { '/user/terms' }
      let(:expected_terms) { general_terms_scopes }

      it_behaves_like 'has expected terms'
    end

    scenario 'visit any other path' do
      visit '/'

      expect(page).to have_text('Start Practicing')
    end

    context 'visit forum' do
      let(:terms_path) { '/discussions/terms' }

      context 'with enabled forum' do
        before { test_organization.update! forum_enabled: true }

        scenario 'visit forum' do
          visit '/discussions/terms'
          expect(page).to have_text('You may have mistyped the address or the page may have moved')
        end
      end
    end
  end

  context 'with incognito mode' do
    before { test_organization.update! incognito_mode_enabled: true }

    describe 'visit user terms path' do
      let(:terms_path) { '/user/terms' }
      let(:expected_terms) { general_terms_scopes }

      it_behaves_like 'has expected terms'
    end

    scenario 'visit any other path' do
      visit '/'

      expect(page).to have_text('Start Practicing')
    end

    context 'visit forum' do
      let(:terms_path) { '/discussions/terms' }

      context 'with enabled forum' do
        before { test_organization.update! forum_enabled: true }

        scenario 'visit forum' do
          visit '/discussions/terms'
          expect(page).to have_text('You may have mistyped the address or the page may have moved')
        end
      end
    end
  end

end

