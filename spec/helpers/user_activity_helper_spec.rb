require 'spec_helper'

describe UserActivityHelper, organization_workspace: :test do
  helper UserActivityHelper

  before do
    # Set today date to Wednesday to test week always starts on Monday
    allow(Date).to receive(:today).and_return(Date.new(2021, 2, 10))
  end

  describe 'activity_selector_week_range' do
    let(:range) { activity_selector_week_range }

    context 'organization without in preparation until' do
      it { expect(range.length).to eq 9 }
      it { expect(range.first).to eq [Date.new(2021, 2, 8), 1.week.since.to_date] }
      it { expect(range.last).to eq [8.week.ago.to_date, 7.week.ago.to_date] }
    end

    context 'organization with in preparation until' do
      let(:organization) { Organization.current }
      before { organization.update! in_preparation_until: 3.week.ago }

      it { expect(range.length).to eq 4 }
      it { expect(range.first).to eq [Date.new(2021, 2, 8), 1.week.since.to_date] }
      it { expect(range.last).to eq [3.week.ago.to_date, 2.week.ago.to_date] }
    end
  end
end
