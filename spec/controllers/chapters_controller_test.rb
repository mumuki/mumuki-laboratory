require 'spec_helper'

describe ChaptersController, type: :controller, organization_workspace: :test do
  describe 'when chapter does not exist' do
    before { get(:show, params: {id: 0}) }

    it { expect(response.status).to eq 404 }
  end
end
