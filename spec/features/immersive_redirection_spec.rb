require 'spec_helper'

feature 'Immersive redirection Flow', organization_workspace: :test, subdomain_redirection_without_port: true do
  def create_guide(name)
    create(:guide, name: name, exercises: [create(:exercise)])
  end

  def create_immersive_organization(name, guides)
    create(:organization,
           name: name,
           immersive: true,
           book:
               create(:book,
                      chapters: [
                          create(:chapter, lessons: guides.map { |it| create(:lesson, guide: it) })
                      ]))
  end

  let(:organization) { Organization.current }
  let(:book) { organization.book }

  let(:guide_one) { create_guide 'guide one' }
  let(:guide_two) { create_guide 'guide two' }
  let(:guide_three) { create_guide 'guide three' }

  let(:lesson_one) { create(:lesson, guide: guide_one) }
  let(:lesson_two) { create(:lesson, guide: guide_two) }
  let(:lesson_three) { create(:lesson, guide: guide_three) }

  before { book.update! chapters: [create(:chapter, lessons: [lesson_one, lesson_two, lesson_three])] }
  before { set_current_user! user }

  shared_examples 'immersive redirection' do |organization_name|
    scenario 'should redirect to immersive organization' do
      expect(page).to have_text organization_name
      expect(page).not_to have_text "Go to #{organization_name}"
    end
  end

  shared_examples 'navigate to content' do |guide_name|
    scenario 'should navigate to content' do
      expect(page).to have_text guide_name
      expect(page).to have_text 'Exercises'
    end
  end

  shared_examples 'navigate to main page' do
    scenario 'should navigate to main page' do
      expect(page).to have_text 'Start Practicing!'
    end
  end

  shared_examples 'navigate to discussions main page' do
    scenario 'should navigate to discussions main page' do
      expect(page).to have_text 'Discussions'
    end
  end

  shared_examples 'navigate to user profile' do
    scenario 'should navigate to user profile' do
      expect(page).to have_text user.full_name
    end
  end

  context 'with one immersive organization' do
    let(:user) { create(:user, permissions: {student: 'immersive-orga/*'}) }
    let!(:immersive_orga) { create_immersive_organization('immersive-orga', [guide_one]) }

    feature 'when navigating to an available content' do
      before { visit lesson_path(lesson_one) }
      it_behaves_like 'immersive redirection', 'immersive-orga'
      it_behaves_like 'navigate to content', 'guide one'
    end

    feature 'when navigating to an unavailable content' do
      before { visit lesson_path(lesson_two) }
      it_behaves_like 'immersive redirection', 'immersive-orga'
      it_behaves_like 'navigate to main page'
    end

    context 'when navigating to a discussion' do
      feature 'and forum enabled' do
        before { immersive_orga.update(forum_enabled: true) }
        before { visit discussions_path }
        it_behaves_like 'immersive redirection', 'immersive-orga'
        it_behaves_like 'navigate to discussions main page'
      end

      feature 'and forum not enabled' do
        before { visit discussions_path }
        it_behaves_like 'immersive redirection', 'immersive-orga'
        it_behaves_like 'navigate to main page'
      end
    end

    feature 'when navigating to another route' do
      before { visit user_path }
      it_behaves_like 'immersive redirection', 'immersive-orga'
      it_behaves_like 'navigate to user profile'
    end
  end

  context 'with many immersive organizations' do
    let(:user) { create(:user, permissions: {student: 'immersive-orga/*:private/*'}) }

    let!(:private_orga) { create_immersive_organization('private', [guide_one, guide_two]) }
    let!(:immersive_orga) { create_immersive_organization('immersive-orga', [guide_one]) }

    shared_examples 'organization chooser' do
      scenario 'should display organization chooser' do
        expect(page).to have_text 'You have registered in another organization'
      end
    end

    def choose_organization(name)
      within '.modal' do
        click_on "Go to #{name}"
      end
    end

    feature 'when content is present in one of them' do
      before { visit lesson_path(lesson_two) }
      it_behaves_like 'immersive redirection', 'private'
      it_behaves_like 'navigate to content', 'guide two'
    end

    feature 'when content is present in two of them' do
      before { visit lesson_path(lesson_one) }
      it_behaves_like 'organization chooser'

      context 'after choosing an organization' do
        before { choose_organization 'private' }
        it_behaves_like 'immersive redirection', 'private'
        it_behaves_like 'navigate to content', 'guide one'
      end
    end

    describe 'when content is not present on any of them' do
      before { visit lesson_path(lesson_three) }
      it_behaves_like 'organization chooser'

      context 'after choosing an organization' do
        before { choose_organization 'immersive-orga' }
        it_behaves_like 'immersive redirection', 'immersive-orga'
        it_behaves_like 'navigate to main page'
      end
    end

    feature 'when navigating to another route' do
      before { visit user_path }
      it_behaves_like 'organization chooser'

      context 'after choosing an organization' do
        before { choose_organization 'immersive-orga' }
        it_behaves_like 'immersive redirection', 'immersive-orga'
        it_behaves_like 'navigate to user profile'
      end
    end

    context 'when navigating to a discussion' do
      before { immersive_orga.update(forum_enabled: true) }
      before { visit discussions_path }

      it_behaves_like 'organization chooser'

      feature 'and forum enabled' do
        before { choose_organization 'immersive-orga' }

        it_behaves_like 'immersive redirection', 'immersive-orga'
        it_behaves_like 'navigate to discussions main page'
      end

      feature 'and forum not enabled' do
        before { choose_organization 'private' }

        it_behaves_like 'immersive redirection', 'private'
        it_behaves_like 'navigate to main page'
      end
    end
  end
end
