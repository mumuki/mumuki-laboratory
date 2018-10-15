require 'spec_helper'

describe Api::UsersController, type: :controller, organization_workspace: :base do
  before { set_api_client! api_client }
  let(:api_client) { create :api_client }
  let(:user_json) do
    {
      first_name: 'foo',
      last_name: 'bar',
      email: 'foo@bar.com',
      permissions: {student: 'test/bar'},
    }
  end

  let(:owner_json) do
    {
      first_name: 'foo',
      last_name: 'bar',
      email: 'foo@bar.com',
      permissions: {owner: '*'}
    }
  end

  context 'post' do
    before { post :create, params: {user: user_json} }

    it { expect(response.status).to eq 200 }
    it { expect(response.body.parse_json).to json_like({uid: 'foo@bar.com',
                                                        first_name: 'foo',
                                                        last_name: 'bar',
                                                        email: 'foo@bar.com',
                                                        permissions: {'student' => 'test/bar'},
                                                        image_url: 'user_shape.png'},
                                                       except: [:id, :created_at, :updated_at]) }
    it { expect(User.count).to eq 2 }
    it { expect(User.last.student? 'test/_').to be true }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end


  context 'post that tries to escalate permissions' do
    before { post :create, params: {user: owner_json} }

    it { expect(response.status).to eq 403 }
    it { expect(response.body).to json_eq errors: ['The operation on organization base was forbidden to user foo+1@bar.com with permissions !janitor:test/*;owner:'] }
  end

  context 'post on a user with high permissions that does not operate on them' do
    let!(:user) { User.create! owner_json }
    before { put :update, params: {id: 'foo@bar.com', user: owner_json} }

    it { expect(response.status).to eq 200 }
  end

  context 'put' do
    before { User.create! user_json }
    before { put :update, params: {id: 'foo@bar.com', user: {first_name: 'Fede'}} }

    it { expect(response.status).to eq 200 }
    it { expect(User.last.first_name).to eq('Fede') }
    it { expect(User.last.uid).to eq 'foo@bar.com' }
  end

end
