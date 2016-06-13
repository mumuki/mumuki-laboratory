require 'spec_helper'

describe CommentsController do
  let!(:user) { create(:user) }

  before { get :index }

  it { expect(response.status).to eq 200 }
  it { expect(response.body).to eq(count: 10) }
end
