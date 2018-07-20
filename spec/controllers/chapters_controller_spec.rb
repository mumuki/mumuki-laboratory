require 'spec_helper'

describe ChaptersController, type: :controller, organization_workspace: :test do
  describe 'when chapter does not exist' do
    before { get :show, params: {id: 0, debatable_class: 'Chapter'} }

    it { expect(response.status).to eq 404 }
  end

  describe 'when chapter exists' do
    let!(:chapter) { create(:chapter) }

    before { get :show, params: {id: chapter.id, debatable_class: 'Chapter'} }

    it { expect(response.status).to eq 200 }
  end
end
