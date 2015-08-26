require 'spec_helper'

describe 'api controller' do
  include AuthHelper

  let(:token) { ApiToken.create!(description: 'token for testing') }

  before { http_login(token.client_id, token.client_secret) }

  describe Api::ExercisesController do
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
end
