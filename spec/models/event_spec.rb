require 'spec_helper'

describe Event do

  describe '#to_job_params!' do
    let(:subscriber) { EventSubscriber.create!(id: 2, enabled: true, url: 'http://localhost:80') }
    let(:user) { create(:user) }
    let(:job_params) { event.to_job_params(subscriber) }

    describe Event::Submission do
      let(:assignment) { create(:exercise).submit_solution!(user) }

      let(:event) { Event::Submission.new(assignment) }

      it { expect(job_params.subscriber_id).to eq 2 }
      it { expect(job_params.event_json).to include '"status":"failed"' }
    end

  end

  describe '#to_json' do

    describe Event::Submission do
      let(:user) { create(:user, id: 2, name: 'foo', provider: 'auth0', uid: 'github|gh1234') }
      let(:lesson) { create(:lesson, number: 4) }
      let(:assignment) { create(:assignment,
                                solution: 'x = 2',
                                status: Status::Passed,
                                submissions_count: 2,
                                submitter: user,
                                submission_id: 'abcd1234',
                                exercise: create(:exercise, guide: create(:guide, lesson: lesson))) }
      let(:event) { Event::Submission.new(assignment) }
      let(:json) { event.as_json.deep_symbolize_keys }

      it do
        expect(json).to eq(status: Status::Passed,
                           result: nil,
                           expectation_results: nil,
                           feedback: nil,
                           test_results: nil,
                           submissions_count: 2,
                           exercise: {
                               id: assignment.exercise.id,
                               name: assignment.exercise.name,
                               number: assignment.exercise.number},
                           guide: {
                               slug: assignment.guide.slug,
                               name: assignment.guide.name,
                               chapter: {
                                 id: assignment.guide.chapter.id,
                                 name: assignment.guide.chapter.name
                               },
                               lesson: {
                                 number: 4,
                               },
                               language: {
                                   name: assignment.guide.language.name}},
                           submitter: {
                               social_id: 'github|gh1234',
                               name: 'foo',
                               email: nil,
                               image_url: nil},
                           id: 'abcd1234',
                           created_at: assignment.updated_at,
                           content: 'x = 2',
                           tenant: 'test')
      end
    end
  end


end
