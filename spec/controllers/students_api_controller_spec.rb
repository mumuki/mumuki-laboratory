require 'spec_helper'

[:student, :teacher].each do |role|

  describe "Api::#{role.capitalize}sController".constantize, type: :controller, organization_workspace: :base do
    before { set_api_client! api_client }
    let(:api_client) { create :api_client, grant: 'anorganization/*' }
    let(:json) { {
        first_name: 'Agustin',
        last_name: 'Pina',
        email: 'agus@mumuki.org',
        uid: 'agus@mumuki.org'
    } }

    let!(:organization) { create :organization, name: 'anorganization' }
    let!(:course) { create :course, slug: 'anorganization/acode' }

    context 'post' do
      let(:params) { {role => json, organization: 'anorganization', course: 'acode'} }

      context 'when user does not exist' do

        before { post :create, params: params }

        it { expect(response.status).to eq 200 }
        it { expect(User.count).to eq 2 }
        it { expect(User.last.last_name).to eq 'Pina' }
        it { expect(User.last.first_name).to eq 'Agustin' }
        it { expect(User.last.uid).to eq 'agus@mumuki.org' }
        it { expect(User.last.email).to eq 'agus@mumuki.org' }
        it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be true }

      end
      context 'when user exist' do
        context 'and have no permissions' do
          before { create :user, json }
          before { post :create, params: params }
          it { expect(response.status).to eq 200 }
          it { expect(User.count).to eq 2 }
          it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be true }
        end
        context 'and have permissions' do
          before { create :user, json.merge(:permissions => {role => 'foo/bar'}) }
          before { post :create, params: params }
          it { expect(response.status).to eq 200 }
          it { expect(User.count).to eq 2 }
          it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be true }
          it { expect(User.last.permissions.has_permission? role, 'foo/bar').to be true }
        end


      end
    end

    context 'attach' do
      let(:params) { {uid: json[:uid], organization: 'anorganization', course: 'acode'} }

      context 'when user does not exist' do
        before { post :attach, params: params }
        it { expect(response.status).to eq 404 }
      end

      context 'when user exist' do
        context 'and have no permissions' do
          before { create :user, json }
          before { post :attach, params: params }
          it { expect(response.status).to eq 200 }
          it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be true }
        end
        context 'and have permissions' do
          before { create :user, json.merge(:permissions => {role => 'foo/bar'}) }
          before { post :attach, params: params }
          it { expect(response.status).to eq 200 }
          it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be true }
          it { expect(User.last.permissions.has_permission? role, 'foo/bar').to be true }
        end
      end

    end

    context 'detach' do
      let(:params) { {uid: json[:uid], organization: 'anorganization', course: 'acode'} }

      context 'when user does not exist' do
        before { post :detach, params: params }
        it { expect(response.status).to eq 404 }
      end

      context 'when user exist' do
        context 'and have permissions' do
          before { create :user, json.merge(:permissions => {role => 'anorganization/acode'}) }
          before { post :detach, params: params }
          it { expect(response.status).to eq 200 }
          it { expect(User.last.permissions.has_permission? role, 'anorganization/acode').to be false }
        end
      end

    end
  end

end
