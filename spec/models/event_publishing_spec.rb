require 'spec_helper'
require 'rspec/mocks'

describe 'events' do
  let(:exercise) { create(:exercise) }
  let(:assignment) { create(:assignment, exercise: exercise) }

  before { organization.switch! }
  before { create(:chapter, lessons: [ create(:lesson, exercises: [ exercise ]) ]) }
  before { reindex_current_organization! }

  describe '#notify!' do
    let!(:organization) { create(:organization, name: 'pdep') }
    before { expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Deaf).to receive(:notify!) }
    before { organization.switch! }

    it { expect { assignment.notify! }.to_not raise_error }
  end

  describe 'protect in central book' do
    let!(:organization) { create(:organization, name: 'central') }
    before { expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Deaf).to receive(:notify!) }
    before { organization.switch! }

    it { expect { assignment.notify! }.to_not raise_error }
  end

  describe 'submit_solution!' do
    let!(:organization) { create(:organization, name: 'pdep') }
    before { expect_any_instance_of(Mumukit::Nuntius::NotificationMode::Deaf).to receive(:notify!) }
    before { organization.switch! }
    let(:user) { create(:user) }

    it { expect { exercise.submit_solution! user }.to_not raise_error }
  end
end
