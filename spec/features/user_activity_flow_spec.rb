require 'spec_helper'

feature 'User Activity Flow', organization_workspace: :test do
  let(:user) { create(:user) }
  let(:organization) { Organization.locate!('test') }

  before { set_current_user!(user) }

  let(:fake_stats) { double('stats') }
  before do
    allow(UserStats).to receive(:stats_for).and_return(fake_stats)
    allow(fake_stats).to receive(:activity).and_return(
        { exercises: { solved_count: 8, count: 10 },
          messages: { count: 12, approved: 6 } })
  end

  let(:week_start) { Time.new(2020, 10, 12) }
  before do
    allow(Time).to receive(:now).and_return(week_start)
  end

  context 'total' do
    before { visit activity_user_path }

    scenario 'displays exercises done percentage' do
      expect(page).to have_text('80%')
      expect(page).to have_text('done')
    end

    scenario 'displays exercises solved count' do
      expect(page).to have_text('8')
      expect(page).to have_text('solved')
    end

    scenario 'displays recent weeks' do
      expect(page).to have_text 'Week of 2020-10-12'
      expect(page).to have_text 'Week of 2020-10-05'
      expect(page).to have_text 'Week of 2020-09-28'
    end

    context 'on organization with no forum' do
      scenario 'does not display messages count' do
        expect(page).to_not have_text('messages')
      end

      scenario 'does not display validated messages count' do
        expect(page).to_not have_text('validated')
      end
    end

    context 'on organization with forum' do
      before do
        organization.update! forum_enabled: true
        visit activity_user_path
      end

      scenario 'displays messages count' do
        expect(page).to have_text('12')
        expect(page).to have_text('messages')
      end

      scenario 'displays validated messages count' do
        expect(page).to have_text('6')
        expect(page).to have_text('validated')
      end
    end

  end

  context 'selecting a specific week' do
    before do
      visit activity_user_path
      click_on 'Week of 2020-10-12'
    end

    scenario "redirects to week activity" do
      expect(page).to have_current_path('/user/activity?date_from=2020-10-12&date_to=2020-10-19')
    end

    scenario "doesn't display exercises done percentage" do
      expect(page).not_to have_text('80%')
      expect(page).not_to have_text('done')
    end
  end
end
