require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  describe '#notify_submission!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:solution) { create(:solution) }

    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_submission!(solution) }
  end
end
