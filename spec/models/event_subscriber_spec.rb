require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  describe '#notify_submission!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:submission) { create(:submission) }

    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_submission!(submission) }
  end
end
