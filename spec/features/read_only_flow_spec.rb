require 'spec_helper'

feature 'Read Only Flow' do

  let(:organization) { create :organization, name: 'private', forum_enabled: true, public: false, faqs: 'FAQs', book: book }
  let(:user) { create :user }
  let(:other_user) { create :user }

  let(:slug) { Mumukit::Auth::Slug.join_s organization.name, 'foo' }

  let(:exercise111) { create :exercise, name: 'Exercise 111' }
  let(:exercise112) { create :exercise, name: 'Exercise 112' }
  let(:exercise121) { create :exercise, name: 'Exercise 121' }
  let(:exercise122) { create :exercise, name: 'Exercise 122' }
  let(:exercise211) { create :exercise, name: 'Exercise 211' }
  let(:exercise212) { create :exercise, name: 'Exercise 212' }
  let(:lesson11) { create :lesson, name: 'Lesson 11', exercises: [exercise111, exercise112] }
  let(:lesson12) { create :lesson, name: 'Lesson 12', exercises: [exercise121, exercise122] }
  let(:lesson21) { create :lesson, name: 'Lesson 21', exercises: [exercise211, exercise212] }
  let(:chapter1) { create :chapter, name: 'Chapter 1', lessons: [lesson11, lesson12] }
  let(:chapter2) { create :chapter, name: 'Chapter 2', lessons: [lesson21] }
  let(:book) { create :book, chapters: [chapter1, chapter2] }

  let(:assignment111) { build :assignment, submitter: user, organization: organization, exercise: exercise111, status: :failed }
  let(:discussion111) { build :discussion, initiator: assignment111.user, item: assignment111.exercise, organization: assignment111.organization }

  let(:assignment112) { build :assignment, submitter: other_user, organization: organization, exercise: exercise112, status: :failed }
  let(:discussion112) { build :discussion, initiator: assignment112.user, item: assignment112.exercise, organization: assignment112.organization }

  before { set_subdomain_host! organization.name }

  before { set_current_user! user }

  before { assignment111.save! }
  before { discussion111.save! }
  before { discussion112.save! }

  context 'in private organization' do
    context 'when organization is enabled' do
      context 'and user is teacher of organization' do
        before { user.update! permissions: { teacher: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('Classroom')
          expect(page).to have_text('Solve other\'s doubts')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
      end

      context 'and user is student of organization' do
        before { user.update! permissions: { student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('Solve other\'s doubts')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('Discussions')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Comment')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Publish discussion')
        end
      end

      context 'and user is ex student of organization' do
        before { user.update! permissions: { ex_student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).not_to have_text('Chapter 2')
          expect(page).not_to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).not_to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_text('Exercise 112')
          expect(page).not_to have_text('Exercise 121')
          expect(page).not_to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_text('Exercise 112')
          expect(page).not_to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'reattach book' do
          expect(book.has_progress_for?(user, organization)).to eq true
          visit "/"
          expect(page).to have_text('Chapters')
          organization.update! book: create(:book_with_full_tree)
          organization.reload
          visit "/"
          expect(page).not_to have_text('Chapters')
          organization.update! book: book
          organization.reload
          visit "/"
          expect(page).to have_text('Chapters')
        end
      end

      context 'and user is outsider of organization' do
        before { user.update! permissions: { ex_student: '', student: '', teacher: '' } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).not_to have_text('My account')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
      end
    end

    context 'when organization is in preparation' do
      before { organization.update! in_preparation_until: 1.day.since }

      context 'and user is teacher of organization' do
        before { user.update! permissions: { teacher: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('Classroom')
          expect(page).to have_text('Solve other\'s doubts')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
      end

      context 'and user is student of organization' do
        before { user.update! permissions: { student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).not_to have_text('My account')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('This path hasn\'t started yet')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('This path hasn\'t started yet')
        end
      end

      context 'and user is ex student of organization' do
        before { user.update! permissions: { ex_student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).not_to have_text('My account')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
      end

      context 'and user is outsider of organization' do
        before { user.update! permissions: { ex_student: '', student: '', teacher: '' } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).not_to have_text('My account')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
      end
    end

    context 'when organization is disabled' do
      before { organization.update! disabled_from: 1.day.ago }

      context 'and user is teacher of organization' do
        before { user.update! permissions: { teacher: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('Classroom')
          expect(page).to have_text('Solve other\'s doubts')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).not_to have_text('You are not allowed to see this content')
        end
      end

      context 'and user is student of organization' do
        before { user.update! permissions: { student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).to have_text('My doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).not_to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).not_to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_selector(:link_or_button, 'Comment')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).not_to have_selector(:link_or_button, 'Comment')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).not_to have_selector(:link_or_button, 'Comment')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
      end

      context 'and user is ex student of organization' do
        before { user.update! permissions: { ex_student: slug } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).to have_text('FAQs')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).not_to have_text('Chapter 1')
          expect(page).not_to have_text('Chapter 2')
          expect(page).not_to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('FAQs')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Page was not found')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('Page was not found')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('Page was not found')
        end
      end

      context 'and user is outsider of organization' do
        before { user.update! permissions: { ex_student: '', student: '', teacher: '' } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).not_to have_text('My account')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('You are not allowed to see this content')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('You are not allowed to see this content')
        end
      end
    end
  end

  context 'in public organization' do
    let(:organization) { create :public_organization, book: book }
    context 'when organization is enabled' do
      context 'and user is outsider of organization' do
        before { user.update! permissions: { ex_student: '', student: '', teacher: '' } }
        scenario 'avatar dorpdown' do
          visit "/"
          find('#profileDropdown').click
          expect(page).to have_text('My account')
          expect(page).not_to have_text('Classroom')
          expect(page).not_to have_text('Bibliotheca')
          expect(page).not_to have_text('FAQs')
          expect(page).not_to have_text('My doubts')
          expect(page).not_to have_text('Solve other\'s doubts')
          expect(page).to have_text('Sign Out')
        end
        scenario 'show book' do
          visit "/"
          expect(page).to have_text('Chapter 1')
          expect(page).to have_text('Chapter 2')
          expect(page).to have_text('Practicing!')
        end
        scenario 'show chapter' do
          visit "/chapters/#{chapter1.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Lesson 12')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Exercise 121')
          expect(page).to have_text('Exercise 122')
        end
        scenario 'show lesson' do
          visit "/lessons/#{lesson11.id}"
          expect(page).to have_text('Lesson 11')
          expect(page).to have_text('Exercise 111')
          expect(page).to have_text('Exercise 112')
          expect(page).to have_text('Continue this lesson!')
        end
        scenario 'show exercise 111' do
          visit "/exercises/#{exercise111.id}"
          expect(page).to have_text('Exercise 111')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show exercise 112' do
          visit "/exercises/#{exercise112.id}"
          expect(page).to have_text('Exercise 112')
          expect(page).to have_selector(:link_or_button, 'Submit')
          expect(page).not_to have_text('Solve your doubts')
        end
        scenario 'show profile' do
          visit "/user"
          expect(page).to have_text('My profile')
        end
        scenario 'show faqs' do
          visit "/faqs"
          expect(page).to have_text('Page was not found')
        end
        scenario 'show discussion' do
          visit "/discussions"
          expect(page).to have_text('Page was not found')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise111.id}/discussions/#{discussion111.id}"
          expect(page).to have_text('Page was not found')
        end
        scenario 'show discussion in existent exercise' do
          visit "/exercises/#{exercise112.id}/discussions/#{discussion112.id}"
          expect(page).to have_text('Page was not found')
        end
        scenario 'new discussion' do
          visit "/exercises/#{exercise112.id}/discussions/new"
          expect(page).to have_text('Page was not found')
        end
      end
    end
  end
end
