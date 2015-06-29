require 'spec_helper'

describe 'api controller' do
  include AuthHelper

  let(:token) { ApiToken.create!(description: 'token for testing') }

  before { http_login(token.client_id, token.client_secret) }

  describe Api::ExercisesController do
    describe '#index' do
      context 'when there are no exercises ' do
        before { get :index }
        it { expect(response.body).to eq '{"exercises":[]}' }
      end

      context 'when there are exercises' do
        let!(:exercise_1) { create(:exercise, title: 'exercise_1', id: 1) }
        let!(:exercise_2) { create(:exercise, title: 'exercise_2', id: 2) }

        describe 'when not using filters' do
          before { get :index }
          it { expect(response.body).to eq '{"exercises":[{"id":1,"title":"exercise_1"},{"id":2,"title":"exercise_2"}]}' }
        end

        describe 'when using filters' do
          before { get :index, exercises: [1, 5, 8] }
          it { expect(response.body).to eq '{"exercises":[{"id":1,"title":"exercise_1"}]}' }
        end
      end
    end

    describe '#show' do
      let!(:exercise_1) { create(:exercise, title: 'exercise_1', id: 1) }
      before { get :show, {id: 1} }
      it { expect(JSON.parse(response.body).slice(:id, :title, :description, :hint)).to eq exercise_1.as_json(only: [:id, :title, :description, :hint]) }
    end
  end


  describe Api::SubmissionsController do
    describe '#create' do
      context 'when it is a valid json' do
        let!(:exercise_1) { create(:exercise, title: 'exercise_1', id: 1) }

        describe 'when not using filters' do
          before { post :create, '{"submitter_id":1, "exercise_id": 1, "content":"foo"}' }

          it { expect(response.body).to eq '{"exercises":[{"id":1,"title":"exercise_1"},{"id":2,"title":"exercise_2"}]}' }
        end
      end
    end

    describe '#index' do
      context 'when there are no submissions ' do
        before { get :index }
        it { expect(response.body).to eq '{"submissions":[]}' }
      end

      context 'when there are submissions' do
        let(:exercise) { create(:exercise, id: 1) }
        let(:user) { create(:user, name: 'user1') }

        context 'when not using filters' do
          context 'when there are successful submissions ' do
            before { exercise.submissions.create!(status: :passed, result: 'all ok', content: 'foo', submitter: user) }
            before { get :index }

            it { expect(response.body).to eq '{"submissions":[{"username":"user1","content":"foo","passed":true}]}' }
          end

          context 'when there are failed submissions ' do
            before { exercise.submissions.create!(status: :failed, result: 'test 1 failed', content: 'foo', submitter: user) }
            before { get :index }

            it { expect(response.body).to eq '{"submissions":[{"username":"user1","content":"foo","passed":false,"result":"test 1 failed"}]}' }
          end
        end

        context 'when using filters' do
          let(:exercise_2) { create(:exercise, id: 2) }

          before { exercise_2.submissions.create!(status: :passed, result: 'all ok', content: 'bar', submitter: user) }

          it do
            get :index, users: %w{user1 user2}, exercises: [2, 3]
            expect(response.body).to eq '{"submissions":[{"username":"user1","content":"bar","passed":true}]}'
          end

          it do
            get :index, users: %w{user1 user2}, exercises: [3]
            expect(response.body).to eq '{"submissions":[]}'
          end

          it do
            get :index, users: %w{user2}, exercises: [2, 3]
            expect(response.body).to eq '{"submissions":[]}'
          end
        end
      end
    end
  end
end
