require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

  describe '#notify_sync!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'localhost:80') }
    let!(:assignment) { create(:assignment) }


    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end

  describe '#notify_async!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'localhost:80') }
    let!(:assignment) { create(:assignment) }

    before { allow_any_instance_of(RestClient).to receive(:post).with('test.localhost:80/submissions').and_return('ok!') }

    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end

end
