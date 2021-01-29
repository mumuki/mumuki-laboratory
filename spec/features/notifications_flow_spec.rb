require 'spec_helper'

feature 'Notifications Flow', organization_workspace: :test do
  let!(:chapter) { create(:chapter) }
  let(:organization) { Organization.current }
  let(:user) { create(:user) }

  before { reindex_current_organization! }
  before { set_current_user!(user) }

  def notifications_bell
    find '.badge-notifications'
  end

  def find_notification_number(number)
    find "#notificationsPanel li:nth-child(#{number}) a"
  end

  context 'user with notifications' do
    let(:exam_registration) { create(:exam_registration, description: 'Mid term exam 2020') }
    let(:exam_authorization_request) { create(:exam_authorization_request, exam_registration: exam_registration, user: user) }

    let!(:notifications) do
      [exam_registration, exam_authorization_request].map { |target| create(:notification, user: user, target: target ) }
    end

    before { visit '/' }

    scenario 'displays count on navigation bar' do
      expect(notifications_bell).to have_text('2')
    end

    scenario 'navigates to target on notification click' do
      find_notification_number(2).click
      expect(page).to have_text 'Registration to Mid term exam 2020'
      expect(page).to have_text 'Choose date and time to attend to the exam'
    end

    scenario 'removes notification after target is processed' do
      # Notification for exam authorization request is considered read after user click
      find_notification_number(1).click
      expect(notifications_bell).to have_text('1')
    end
  end
end
