require 'spec_helper'

describe ExamAuthorizationRequestsController, type: :controller, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:exam) { create(:exam) }
  let(:exam_registration) { create(:exam_registration, exams: [exam]) }

  before { set_current_user! user }

  describe 'create' do
    let!(:notification) { create(:notification, target: exam_registration, user: user) }

    def do_post
      post :create, params: {
        exam_authorization_request: { exam_id: exam.id, exam_registration_id: exam_registration.id }
      }
    end

    before { do_post }

    describe 'called once' do
      it { expect(response.status).to eq 302 }
      it { expect(exam_registration.authorization_requests.size).to be 1 }
      it { expect(notification.reload.read).to be_truthy }
    end

    describe 'called twice' do
      before { do_post }
      it { expect(response.status).to eq 302 }
      it { expect(exam_registration.authorization_requests.size).to be 1 }
      it { expect(notification.reload.read).to be_truthy }
    end
  end

  describe 'update' do
    let(:exam_authorization_request) { create :exam_authorization_request, exam: exam, exam_registration: exam_registration, user: user }

    before do
      put :update, params: {
        id: exam_authorization_request.id,
        exam_authorization_request: { exam_id: exam.id, exam_registration_id: exam_registration.id }
      }
    end

    it { expect(response.status).to eq 302 }
    it { expect(exam_registration.authorization_requests.size).to be 1 }
  end

  describe 'fails if exam_registration time ended' do
    let(:exam_registration) { create(:exam_registration, exams: [exam], end_time: 2.minutes.ago) }
    let(:exam_authorization_request) { create :exam_authorization_request, exam: exam, exam_registration: exam_registration, user: user }

    describe 'create' do
      before do
        post :create, params: {
          exam_authorization_request: { exam_id: exam.id, exam_registration_id: exam_registration.id }
        }
      end
      it { expect(response.status).to eq 410 }
    end

    describe 'update' do
      before do
        put :update, params: {
          id: exam_authorization_request.id,
          exam_authorization_request: { exam_id: exam.id, exam_registration_id: exam_registration.id }
        }
      end
      it { expect(response.status).to eq 410 }
    end
  end

end
