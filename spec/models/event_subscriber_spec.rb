require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  describe '#notify_sync!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:assignment) { create(:assignment) }

    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end

  describe Event::Submission do
    let(:user) { create(:user, id: 2, name: 'foo') }
    let(:assignment) { create(:assignment,
                              solution: 'x = 2',
                              status: Status::Passed,
                              submissions_count: 2,
                              submitter: user,
                              submission_id: 'abcd1234') }
    let(:event) { Event::Submission.new(assignment) }

    it { expect(event.as_json).to eq({'status' => Status::Passed,
                                      'result' => nil,
                                      'expectation_results' => nil,
                                      'feedback' => nil,
                                      'test_results' => nil,
                                      'submissions_count' => 2,
                                      'exercise' => {'id' => assignment.exercise.id, 'guide_id' => nil},
                                      'submitter' => {'id' => 2, 'name' => 'foo'},
                                      'id' => 'abcd1234',
                                      'created_at' => assignment.updated_at,
                                      'content' => 'x = 2'
                                     }) }
  end

end
