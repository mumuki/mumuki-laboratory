require 'spec_helper'

feature 'private org' do
  let(:private_organization) do
    create(:organization,
           name: 'private',
           private: true,
           book: create(:book, name: 'private', slug: 'mumuki/mumuki-the-private-book'))
  end

  before { set_subdomain_host! private_organization.name }
  before { private_organization.switch! }

  context 'anonymous user' do
    scenario 'should not access' do
      visit '/guides'

      expect(page).not_to have_text('Nobody created a guide for this search yet')
    end
  end

  context 'logged user' do
    let(:visitor) { create(:user) }
    let(:student) { create(:user, permissions: {student: 'private/*'}) }
    let(:teacher) { create(:user, permissions: {student: 'private/*', teacher: 'private/*'}) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:from_sessions?).and_return(false)
    end

    scenario 'visitor should raise forbidden error' do
      set_current_user! visitor

      visit '/guides'
      expect(page).to have_text('You are not allowed to see this content.')
      expect(visitor.reload.last_organization).to be nil
    end

    scenario 'student should access' do
      set_current_user! student

      visit '/guides'

      expect(page).to have_text('Which guide do you want to do today?')
      expect(student.reload.last_organization).to eq Organization.current
    end

    scenario 'teacher should access' do
      set_current_user! teacher

      visit '/guides'

      expect(page).to have_text('Which guide do you want to do today?')
      expect(teacher.reload.last_organization).to eq Organization.current
    end
  end
end
