require 'spec_helper'

describe UsersController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user, email: 'pirulo@mail.com') }

  let(:user_json) do
    {
      first_name: 'foo',
      last_name: 'bar',
      email: 'foo@bar.com'
    }
  end

  context 'put' do
    before { set_current_user! user }
    before { put :update, body: { user: user_json }.to_json, as: :json }

    it { expect(User.last.first_name).to eq 'foo' }
    it { expect(User.last.verified_first_name).to be_nil }
  end

  context 'notifications' do
    context 'get' do
      context 'when logged in' do
        before { set_current_user! user }
        before { get :notifications }

        it { expect(response.status).to eq 200 }
      end

      context 'when not logged in' do
        before { get :notifications }

        it { expect(response.status).to eq 302 }
      end
    end

    context 'toggle_read' do
      before { set_current_user! user }
      before { post :toggle_read, params: { id: notification.id } }

      context 'on toggling own notification read' do
        let(:notification) { create :notification, user: user }

        it { expect(response.status).to eq 302 }
        it { expect(notification.reload.read?).to be true }
      end

      context 'on toggling someone else\'s notification read' do
        let(:notification) { create :notification, user: create(:user) }

        it { expect(response.status).to eq 404 }
        it { expect(notification.reload.read?).to be false }
      end
    end

    context 'notifications/manage' do
      context 'post' do
        let(:user) { create :user, ignored_notifications: [] }

        before { set_current_user! user }
        before { post :manage_notifications, params: { notifications: {'custom' => 1, 'exam_registrations' => 0 } } }

        it { expect(response.status).to eq 302 }
        it { expect(flash.notice).to eq 'Preferences updated successfully' }
        it { expect(user.reload.ignored_notifications).to eq ['exam_registrations'] }
      end
    end
  end

  context 'send_delete_confirmation_email' do
    let(:last_email) { ActionMailer::Base.deliveries.last }
    before { set_current_user! user }
    before { post :send_delete_confirmation_email }

    context 'sends a delete confirmation email' do
      it { expect(last_email.to).to eq ['pirulo@mail.com'] }
      it { expect(last_email.subject).to have_content 'Delete your Mumuki account' }
    end

    context 'adds a delete token to the user' do
      it { expect(user.reload.delete_account_token).not_to be_nil }
    end

    context 'redirects to confirmation view' do
      it { expect(response).to redirect_to(delete_request_user_path) }
    end
  end
end
