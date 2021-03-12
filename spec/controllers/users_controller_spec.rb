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

  before { set_current_user! user }

  context 'put' do
    before { put :update, body: { user: user_json }.to_json, as: :json }

    it { expect(User.last.first_name).to eq 'foo' }
    it { expect(User.last.verified_first_name).to be_nil }
  end

  context 'send_delete_confirmation_email' do
    let(:last_email) { ActionMailer::Base.deliveries.last }
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
