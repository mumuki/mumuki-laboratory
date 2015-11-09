require 'spec_helper'

describe Event do

  describe '#to_job_params!' do
    let(:user) { create(:user) }
    let(:event) { Event::Registration.new(user) }
    let(:subscriber) { EventSubscriber.create!(id: 2, enabled: true, url: 'http://localhost:80') }
    let(:job_params) { event.to_job_params(subscriber) }

    it { expect(job_params.subscriber_id).to eq 2 }
    it { expect(job_params.event_json).to_not include 'token' }
    it { expect(job_params.event_path).to eq 'events/registration' }
  end

end
