require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do
  let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
  let!(:assignment) { create(:assignment) }
  let(:user) { create(:user) }
  let(:exercise) { create(:x_equal_5_exercise) }

  describe '#notify!' do
    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify!(Event::Submission.new(assignment)) }
  end

  describe 'protect in central book' do
    let!(:organization) { Organization.find_or_create_by(name: 'central') }

    it 'EventSubscriber does not send event when book is central' do
      organization.switch!
      expect_any_instance_of(EventSubscriber).not_to receive(:do_request)
      EventSubscriber.notify!(Event::Submission.new(assignment))
    end
  end

  describe 'test event subscriber api' do
    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it 'run notifier when submit a solution' do
      expect { exercise.submit_solution! user }.to_not raise_error
    end
  end

  describe 'test event queue_name' do
    it 'submission event queue_name is submissions' do
      expect(Mumukit::Nuntius::Publisher).to receive(:publish_submissions)
      expect { exercise.submit_solution! user }.to_not raise_error
    end

    it 'submissions mock queue_name is comments' do
      expect_any_instance_of(Event::Submission).to receive(:queue_name).and_return('comments')
      expect(Mumukit::Nuntius::Publisher).to receive(:publish_comments)
      expect { exercise.submit_solution! user }.to_not raise_error
    end
  end

end
