require "spec_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "we_miss_you_reminder" do
    let(:reminder) { user.build_reminder }
    let(:central) { create(:organization, name: 'central') }
    let(:user) { build :user, last_organization: central, last_submission_date: days_since_last_submission.days.ago, last_reminded_date: days_since_last_reminded.days.ago }

    let(:days_since_last_submission) { 9 }
    let(:days_since_last_reminded) { 8 }


    it "renders the headers" do
      expect(reminder.subject).to eq("We miss you!")
      expect(reminder.to).to eq([user.email])
      expect(reminder.from).to eq(["support@mumuki.org"])
    end

    context 'last reminded over 1 week ago' do
      let(:days_since_last_reminded) { 8 }

      context "last submission this week" do
        let(:days_since_last_submission) { 3 }

        it { expect(user.should_send_reminder?).to be false }
      end

      context "last submission 1 week ago" do
        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("Keep learning") }
      end

      context "last submission 2 weeks ago" do
        let(:days_since_last_submission) { 16 }

        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("Keep learning") }
      end

      context "last submission 3 weeks ago" do
        let(:days_since_last_submission) { 26 }

        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("Keep learning") }
      end

      context "last submission 4 weeks ago" do
        let(:days_since_last_submission) { 30 }

        it { expect(user.should_send_reminder?).to be false }
      end
    end

    context 'last reminded this week' do
      let(:days_since_last_reminded) { 2 }

      context "last submission this week" do
        let(:days_since_last_submission) { 3 }

        it { expect(user.should_send_reminder?).to be false }
      end

      context "last submission 1 week ago" do
        it { expect(user.should_send_reminder?).to be false }
      end
    end
  end

  describe "no_submissions_reminder" do
    let(:reminder) { user.build_reminder }
    let(:central) { create(:organization, name: 'central') }
    let(:user) { build :user, last_organization: central, last_submission_date: nil, last_reminded_date: days_since_last_reminded.days.ago, created_at: days_since_user_creation.days.ago }

    let(:days_since_last_reminded) { 8 }
    let(:days_since_user_creation) { 8 }

    it "renders the headers" do
      expect(reminder.subject).to eq("Start using Mumuki!")
      expect(reminder.to).to eq([user.email])
      expect(reminder.from).to eq(["support@mumuki.org"])
    end

    context 'last reminded over 1 week ago' do
      let(:days_since_last_reminded) { 8 }

      context "registered this week" do
        let(:days_since_user_creation) { 3 }

        it { expect(user.should_send_reminder?).to be false }
      end

      context "registered 1 week ago" do
        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("you've never submitted solutions") }
      end

      context "last submission 2 weeks ago" do
        let(:days_since_user_creation) { 16 }

        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("you've never submitted solutions") }
      end

      context "last submission 3 weeks ago" do
        let(:days_since_user_creation) { 26 }

        it { expect(user.should_send_reminder?).to be true }
        it { expect(reminder.body.encoded).to include("you've never submitted solutions") }
      end

      context "last submission 4 weeks ago" do
        let(:days_since_user_creation) { 30 }

        it { expect(user.should_send_reminder?).to be false }
      end
    end

    context 'last reminded this week' do
      let(:days_since_last_reminded) { 2 }

      it { expect(user.should_send_reminder?).to be false }
    end
  end
end
