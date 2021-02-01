require 'spec_helper'

describe ExamRegistrationsController, type: :controller, organization_workspace: :test do
  describe 'show' do
    context 'when registration does not exist' do
      before { get :show, params: {id: 0} }

      it { expect(response.status).to eq 404 }
    end

    context 'when registration exists' do
      let!(:registration) { create(:exam_registration) }

      before { get :show, params: {id: registration.id} }

      it { expect(response.status).to eq 200 }
    end
  end
end
