require 'spec_helper'

describe ExamAuthorizationRequestsController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:exam) { create(:exam) }
  let(:exam_registration) { create(:exam_registration, exams: [exam]) }

  before { set_current_user! user }

  describe 'show' do
    context 'when authorization does not exist' do
      before { get :show, params: {id: 0} }
      it { expect(response.status).to eq 404 }
    end

    context 'when authorization exists' do
      let(:exam_authorization_request) { create(:exam_authorization_request, user: user, exam_registration: exam_registration) }
      let!(:notification) { create(:notification, target: exam_authorization_request, user: user) }

      before { get :show, params: {id: exam_authorization_request.id} }

      it { expect(response.status).to eq 200 }
      it { expect(notification.reload.read).to be_truthy }
    end
  end

  describe 'create' do
    let!(:notification) { create(:notification, target: exam_registration, user: user) }

    before do
      post :create, params: {
        exam_authorization_request: { exam_id: exam.id, exam_registration_id: exam_registration.id }
      }
    end

    it { expect(response.status).to eq 204 }
    it { expect(exam_registration.authorization_requests.length).to be 1 }
    it { expect(notification.reload.read).to be_truthy }
  end
end
