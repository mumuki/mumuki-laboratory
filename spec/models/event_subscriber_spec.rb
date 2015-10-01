require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  describe '#notify_submission!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:assignment) { create(:assignment) }

    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end
end
