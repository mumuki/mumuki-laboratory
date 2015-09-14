require 'spec_helper'
require 'rspec/expectations'

RSpec::Matchers.define :json_eq do |expected_json_hash|
  match do |actual_json|
    expected_json_hash.with_indifferent_access == ActiveSupport::JSON.decode(actual_json)
  end
end

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
      let!(:exercise_1) { create(:exercise, name: 'exercise_1', id: 1) }
      let!(:exercise_2) { create(:exercise, name: 'exercise_2', id: 2) }

      describe 'when not using filters' do
        before { get :index }
        it { expect(response.body).to eq '{"exercises":[{"id":1,"name":"exercise_1"},{"id":2,"name":"exercise_2"}]}' }
      end

      describe 'when using filters' do
        before { get :index, exercises: [1, 5, 8] }
        it { expect(response.body).to eq '{"exercises":[{"id":1,"name":"exercise_1"}]}' }
      end
    end
  end

  describe Api::GuidesController do
    context 'when there are no guides ' do
      before { get :index }
      it { expect(response.body).to eq '{"guides":[]}' }
    end

    context 'when there are guides with exercises' do
      let!(:language_1) { create(:language, id: 1, name: 'language_1') }
      let!(:guide_1) { create(:guide, name: 'guide_1', id: 1, language_id: language_1.id) }
      let!(:exercise_1) { create(:exercise, name: 'exercise_1', id: 1, language_id: language_1.id, guide_id: guide_1.id) }

      before { get :index }
      let(:expected_json) {
        { guides: [
          {
            id: 1,
            github_repository: 'flbulgarelli/mumuki-sample-exercises',
            name: 'guide_1',
            language: { id: 1, name: 'language_1' },
            position: nil,
            exercises: [
              { id: 1, name: 'exercise_1', position: 1 }
            ]
          }
        ]}
      }

      it { expect(response.body).to json_eq expected_json }
    end

    context 'when there are guides with no exercises' do
      let!(:language_1) { create(:language, id: 1, name: 'language_1') }
      let!(:guide_1) { create(:guide, name: 'guide_1', id: 1, language_id: language_1.id) }

      describe 'when not using filters' do
        before { get :index }
        let(:expected_json) {
          { guides: [
            {
              id: 1,
              github_repository: 'flbulgarelli/mumuki-sample-exercises',
              name: 'guide_1',
              language: { id: 1, name: 'language_1' },
              position: nil,
              exercises: []
            }
          ]}
        }

        it { expect(response.body).to json_eq expected_json }
      end
    end

    context 'when the guide belongs to a path' do
      let!(:category_1) { create(:category, name: 'category_1')  }
      let!(:path_1) { create(:path, id: 1, category_id: category_1.id) }
      let!(:language_1) { create(:language, id: 1, name: 'language_1') }
      let!(:guide_1) { create(:guide, name: 'guide_1', id: 1, language_id: language_1.id, path_id: path_1.id, position: 1) }

      before { get :index }

      let(:expected_json) {
        { guides: [
          {
            id: 1,
            github_repository: 'flbulgarelli/mumuki-sample-exercises',
            name: 'guide_1',
            language: { id: 1, name: 'language_1' },
            path: { id: 1, name: 'category_1' },
            position: 1,
            exercises: []
          }
        ]}
      }

      it { expect(response.body).to json_eq expected_json }
    end
  end
end
