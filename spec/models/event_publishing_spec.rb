require 'spec_helper'
require 'rspec/mocks'

describe 'events' do
  let!(:assignment) { create(:assignment) }
  let(:user) { create(:user) }
  let(:exercise) { create(:x_equal_5_exercise) }

  describe '#notify!' do
    let!(:organization) { create(:organization, name: 'pdep') }
    before { expect_any_instance_of(Event::Base).to receive(:publish!) }
    before { organization.switch! }

    it { expect { Event::Submission.new(assignment).notify! }.to_not raise_error }
  end

  describe 'protect in central book' do
    let!(:organization) { create(:organization, name: 'central') }
    before { expect_any_instance_of(Event::Base).to receive(:publish!) }
    before { organization.switch! }

    it { expect { Event::Submission.new(assignment).notify! }.to_not raise_error }
  end

  describe 'submit_solution!' do
    let!(:organization) { create(:organization, name: 'pdep') }
    before { expect_any_instance_of(Event::Base).to receive(:publish!) }
    before { organization.switch! }

    it { expect { exercise.submit_solution! user }.to_not raise_error }
  end
end
