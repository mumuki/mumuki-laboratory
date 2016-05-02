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

      let(:chapter) {
        create(:chapter, lessons: [
            create(:lesson),
            create(:lesson),
            create(:lesson),
            create(:lesson, exercises: [create(:exercise)])]) }

      let(:lesson) { chapter.lessons.fourth }
      let(:guide) { lesson.guide }
      let(:exercise) { lesson.exercises.first }

      let(:assignment) { create(:assignment,
                                solution: 'x = 2',
                                status: Status::Passed,
                                submissions_count: 2,
                                submitter: user,
                                submission_id: 'abcd1234',
                                exercise: exercise) }
      let(:event) { Event::Submission.new(assignment) }
      let(:json) { event.as_json.deep_symbolize_keys }

      it { expect(lesson.number).to eq 4 }
      it do
        expect(json).to eq(status: Status::Passed,
                           result: nil,
                           expectation_results: nil,
                           feedback: nil,
                           test_results: nil,
                           submissions_count: 2,
                           exercise: {
                               id: exercise.id,
                               name: exercise.name,
                               number: exercise.number},
                           guide: {
                               slug: guide.slug,
                               name: guide.name,
                               chapter: {
                                   id: guide.chapter.id,
                                   name: guide.chapter.name
                               },
                               lesson: {
                                   number: 4,
                               },
                               language: {
                                   name: guide.language.name}},
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
