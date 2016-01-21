require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do

  describe '#notify_sync!' do
    let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:assignment) { create(:assignment) }

    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end

  describe 'tenant_url' do
    let!(:tenant_subscriber) { TenantSubscriber.create!(enabled: true, url: 'http://localhost:80') }

    it { expect(tenant_subscriber.get_url).to eq('http://test.localhost:80') }
  end

end
