require 'spec_helper'

feature 'Delete account Flow', organization_workspace: :test, requires_js: true do
  before { set_current_user! user }

  def accept_delete_confirmation_modal!
    within '#user-delete-account-modal' do
      fill_in 'confirm-delete-input', with: 'delete my account'
      click_on 'delete-account-button'
    end
  end

  context 'Step 1: delete request' do
    let(:user) { create(:user, email: 'pirulo@mail.com') }

    before do
      visit user_path
      click_on 'Delete account'
      accept_delete_confirmation_modal!
    end

    context 'redirects to confirmation view' do
      it { expect(page).to have_text 'We sent you an email to pirulo@mail.com' }
    end
  end

  context 'Step 2: delete confirmation' do
    let(:expiration_date) { 2.days.from_now }
    let(:user) { create(:user, delete_account_token: 'abc1234', delete_account_token_expiration_date: expiration_date) }

    before { visit delete_confirmation_user_path token: token }

    context 'with valid token' do
      let(:token) { 'abc1234' }
      before { accept_delete_confirmation_modal! }
      it { expect(page).to have_text 'You are not allowed to see this content' }
    end

    context 'with invalid token' do
      let(:token) { 'faketoken' }
      it { expect(page).to have_text 'We are sorry, the link has expired or is invalid' }
    end

    context 'with expired token' do
      let(:token) { 'abc1234' }
      let(:expiration_date) { 1.hour.ago }
      it { expect(page).to have_text 'We are sorry, the link has expired or is invalid' }
    end
  end
end
