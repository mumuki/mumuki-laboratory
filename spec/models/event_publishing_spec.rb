require 'spec_helper'
require 'rspec/mocks'

describe 'events' do
  let!(:assignment) { create(:assignment) }
  let(:user) { create(:user) }
  let(:exercise) { create(:x_equal_5_exercise) }

  describe '#notify!' do
    let!(:organization) { Organization.create!(name: 'pdep', contact_email: 'bar@baz.com') }
    before { expect_any_instance_of(Event::Base).to receive(:publish!) }
    before { organization.switch! }

    it { expect { Event::Submission.new(assignment).notify! }.to_not raise_error }
  end

  describe 'protect in central book' do
    let!(:organization) { Organization.create!(name: 'central', contact_email: 'bar@baz.com') }
    before { expect_any_instance_of(Event::Base).to_not receive(:publish!) }
    before { organization.switch! }

    it { expect { Event::Submission.new(assignment).notify! }.to_not raise_error }
  end

  describe 'submit_solution!' do
    let!(:organization) { Organization.create!(name: 'pdep', contact_email: 'bar@baz.com') }
    before { expect_any_instance_of(Event::Base).to receive(:publish!) }
    before { organization.switch! }

    it { expect { exercise.submit_solution! user }.to_not raise_error }
  end
end
