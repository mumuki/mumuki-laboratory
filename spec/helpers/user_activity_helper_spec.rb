require 'spec_helper'

describe UserActivityHelper, organization_workspace: :test do
  helper UserActivityHelper

  let(:organization) { Organization.current }

  before do
    # Set today date to Wednesday to test week always starts on Monday
    allow(Date).to receive(:today).and_return(Date.new(2021, 2, 10))
    allow_any_instance_of(UserActivityHelper).to receive(:min_week).and_return(8.weeks.ago(Date.today))
  end

  describe 'activity_selector_week_range_for' do
    let(:range) { activity_selector_week_range_for organization }
    let(:closest_monday) { Date.new(2021, 2, 8) }

    context 'organization without in preparation until' do
      it { expect(range.length).to eq 9 }
      it { expect(range.first).to eq [closest_monday, 1.week.since(closest_monday).to_date] }
      it { expect(range.last).to eq [8.week.ago(closest_monday).to_date, 7.week.ago(closest_monday).to_date] }
    end

    context 'organization with in preparation until' do
      before { organization.update! in_preparation_until: 3.week.ago(Date.today) }

      it { expect(range.length).to eq 4 }
      it { expect(range.first).to eq [closest_monday, 1.week.since(closest_monday).to_date] }
      it { expect(range.last).to eq [3.week.ago(closest_monday).to_date, 2.week.ago(closest_monday).to_date] }
    end
  end
end
