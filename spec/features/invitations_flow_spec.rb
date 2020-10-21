require 'spec_helper'

feature 'Invitations Flow', organization_workspace: :test do
  let(:organization) { Organization.current }

  let(:guide) { create(:guide) }
  let(:chapter) {
    create(:chapter, lessons: [
      create(:lesson, guide: guide)
    ]) }
  let(:book) { organization.book }

  before do
    book.update! chapters: [chapter]
  end

  let(:permissions) { { } }
  let(:user) { create(:user, permissions: permissions) }
  before { set_current_user!(user) }

  let(:nodejs_course) { create(:course, slug: 'test/nodejs', name: 'Curso de NodeJS', organization: organization) }
  let(:python_course) { create(:course, slug: 'test/python', name: 'Curso de Python', organization: organization) }
  let!(:nodejs_invitation) { create(:invitation, code: 'invitacionAlNodejs', course: nodejs_course) }
  let!(:python_invitation) { create(:invitation, code: 'invitacionAlPython', course: python_course) }

  context 'with no memberships' do
    scenario 'visit invitation' do
      visit '/join/invitacionAlNodejs'
      expect(page).to have_text('Join Curso de NodeJS')
    end
  end

  context 'with existing memberships' do
    let(:permissions) { { student: 'test/nodejs' } }

    scenario 'visit invitation, already joined', :navigation_error do
      visit '/join/invitacionAlNodejs'
      expect(page).to have_text('Start Practicing!')
    end

    scenario 'visit invitation, not joined' do
      visit '/join/invitacionAlPython'
      expect(page).to have_text('Join Curso de Python')
    end
  end
end
