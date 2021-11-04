require 'spec_helper'

feature 'Discussion Flow', organization_workspace: :test do

  ## =============
  ## Users
  ## =============

  let(:student) { create(:user, permissions: {student: 'test/*:other/*:empty/*'}) }
  let(:another_student) { create(:user, permissions: {student: 'test/*:other/*:empty/*'}) }
  let(:moderator) { create(:user, permissions: {moderator: 'test/*:other/*:empty/*', student: 'test/*:other/*:empty/*'}) }

  ## =================
  ## Organizations
  ## =================

  let(:test_organization) { Organization.locate! 'test' }
  let(:other_organization) { create(:organization, name: 'other') }
  let!(:empty_organization) { create(:organization, name: 'empty') }

  ## ================================
  ## Content for test_organization
  ## ================================

  let(:problem_1) { create(:problem) }
  let(:problem_2) { create(:problem) }
  let(:problem_3) { create(:problem) }

  let!(:chapter) {
    create(:chapter, lessons: [create(:lesson, exercises: [ problem_1, problem_2, problem_3])])
  }

  ## =====================================
  ## Discussions for test_organization
  ## =====================================

  let(:problem_2_discussions) { create_list(:discussion, 5, initiator: another_student, item: problem_2, organization: test_organization) }
  let(:problem_3_discussions) { create_list(:discussion, 5, initiator: student, item: problem_2, organization: test_organization) }
  let!(:test_organization_discussions) { problem_2_discussions + problem_3_discussions }

  ## ===================================
  ## Content for other_organization
  ## ===================================

  let(:other_problem) { create(:problem) }
  let!(:other_chapter) {
    create(:chapter, book: other_organization.book, lessons: [create(:lesson, exercises: [other_problem])])
  }

  ## =====================================
  ## Discussions for other_organization
  ## =====================================

  let(:other_problem_discussions) { create_list(:discussion, 5, initiator: student, item: problem_2, organization: other_organization) }
  let!(:other_organization_discussions) { other_problem_discussions }

  before { reindex_current_organization! }
  before { reindex_organization! other_organization }
  before { reindex_organization! empty_organization }

  shared_examples 'no forum access' do
    scenario 'has no forum access' do
      visit current_path
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  context 'exercise discussions' do
    let(:current_path) { "/exercises/#{problem_1.id}/discussions" }

    context 'with no current user' do
      it_behaves_like 'no forum access'
    end

    context 'with logged user' do
      before { set_current_user! student }

      context 'but no forum enabled' do
        it_behaves_like 'no forum access'
      end

      context 'and forum enabled' do
        before { Organization.current.update! forum_enabled: true }

        scenario 'empty discussion list for problem 1' do
          visit "/exercises/#{problem_1.id}/discussions"
          expect(page).to have_text(problem_1.name)
          expect(page).to have_text('It seems there isn\'t any question yet.')
        end

        scenario 'discussion list for problem 2' do
          visit "/exercises/#{problem_2.id}/discussions"
          expect(page).to have_text(problem_2.name)
          problem_2_discussions.each do |discussion|
            expect(page).to have_text(discussion.description)
          end
          expect(page).to have_text('Didn\'t find what you were looking for?')
        end
      end
    end
  end

  context 'book discussions' do
    let(:current_path) { '/discussions' }

    context 'with no current user' do
      it_behaves_like 'no forum access'
    end

    context 'with logged user' do
      before { set_current_user! student }

      context 'but no forum enabled' do
        it_behaves_like 'no forum access'
      end

      context 'and forum enabled' do
        before { Organization.current.update! forum_enabled: true }

        context 'in empty organization' do
          before { empty_organization.update! forum_enabled: true }
          before { set_subdomain_host! 'empty' }
          after { set_subdomain_host! 'test' }

          scenario 'empty discussion list for book without discussions' do
            visit current_path
            expect(page).to have_text(empty_organization.book.name)
            expect(page).to have_text('It seems there isn\'t any question yet.')
          end

        end

        scenario 'discussion list for book with discussions' do
          visit current_path
          expect(page).to have_text(test_organization.book.name)
          test_organization_discussions.each do |discussion|
            expect(page).to have_text(discussion.description)
          end
          other_organization_discussions.each do |discussion|
            expect(page).not_to have_text(discussion.description)
          end
          expect(page).not_to have_text('Didn\'t find what you were looking for?')
          expect(page).not_to have_text('It seems there isn\'t any question yet.')
        end
      end
    end
  end

  context 'exercise discussion' do
    let(:current_path) { "/exercises/#{problem_2.id}/discussions/#{problem_2_discussions.first.id}" }
    before { test_organization.switch! }

    context 'with no current user' do
      it_behaves_like 'no forum access'
    end

    context 'with logged student' do
      before { set_current_user! student }

      context 'but no forum enabled' do
        it_behaves_like 'no forum access'
      end

      context 'and forum enabled' do
        let!(:problem_2_discussion_message) { create(:message, discussion: problem_2_discussions.first, sender: another_student) }
        let!(:another_problem_2_discussion_message) { create(:message, discussion: problem_2_discussions.first, sender: another_student) }
        before do
          Organization.current.update! forum_enabled: true
          another_problem_2_discussion_message.soft_delete! :inappropriate_content, moderator
        end

        scenario 'newly created discussion' do
          visit current_path
          expect(page).to have_text(problem_2.name)
          expect(page).to have_text('Open')
          expect(page).to have_text('Messages')
          expect(page).to_not have_text('I\'ll take care')
          expect(page).not_to have_text('Preview')
          expect(page).to have_text(problem_2_discussion_message.content)
          expect(page).not_to have_text(another_problem_2_discussion_message.content)
          expect(page).not_to have_xpath("//div[@class='discussion-actions']")
          expect(page).to_not have_text('Includes inappropriate content')
          expect(page).to_not have_text('Shares the correct solution')
          expect(page).to_not have_text('Discloses personal information')
          expect(page).to have_text('included inappropriate content')
          expect(page).to_not have_text ("Deleted by #{moderator.name}")
        end

        context 'for moderator' do
          before { set_current_user! moderator }

          context 'on a newly created discussion' do
            scenario do
              visit current_path
              expect(page).to have_text(problem_2.name)
              expect(page).to have_text('Open')
              expect(page).to have_text('Messages')
              expect(page).to have_text('I\'ll take care')
              expect(page).to have_text('Preview')
              expect(page).to have_text(problem_2_discussion_message.content)
              expect(page).to have_text(another_problem_2_discussion_message.content)
              expect(page).to have_xpath("//div[@class='discussion-actions']")
              expect(page).to have_text('Includes inappropriate content')
              expect(page).to have_text('Shares the correct solution')
              expect(page).to have_text('Discloses personal information')
              expect(page).to have_text('included inappropriate content')
              expect(page).to have_text ("Deleted by #{moderator.name}")
            end
          end

          context 'on a discussion where they are responsible' do
            before { problem_2_discussions.first.toggle_responsible! moderator }

            scenario do
              visit current_path
              expect(page).to have_text('I won\'t take care')
            end
          end

          context 'on a discussion where someone else is responsible' do
            let(:another_moderator) { create(:user, permissions: {moderator: '*', student: '*'}) }
            before { problem_2_discussions.first.toggle_responsible! another_moderator }

            scenario do
              visit current_path
              expect(page).not_to have_text('I\'ll take care')
              expect(page).not_to have_text('I won\'t take care')
            end
          end
        end
      end
    end
  end
end
