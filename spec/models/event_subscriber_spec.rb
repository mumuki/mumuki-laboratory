require 'spec_helper'

require 'rspec/mocks'

describe EventSubscriber do
  let!(:subscriber) { EventSubscriber.create!(enabled: true, url: 'http://localhost:80') }
  let!(:assignment) { create(:assignment) }

  describe '#notify_sync!' do
    before { expect_any_instance_of(EventSubscriber).to receive(:do_request).and_return({'status' => 'ok'}.to_json) }

    it { EventSubscriber.notify_sync!(Event::Submission.new(assignment)) }
  end

  describe 'tenant_url' do
    let!(:tenant_subscriber) { TenantSubscriber.create!(enabled: true, url: 'http://localhost:80') }
    let!(:book) { Book.find_or_create_by(name: 'central') }

    it { expect(tenant_subscriber.get_url).to eq('http://test.localhost:80') }

    it 'EventSubscriber does not send event when book is central' do
      book.switch!
      expect_any_instance_of(EventSubscriber).not_to receive(:do_request)
      EventSubscriber.notify_sync!(Event::Submission.new(assignment))
    end
  end

end
