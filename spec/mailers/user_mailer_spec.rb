require "spec_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "we_miss_you_reminder" do
    let(:reminder) { user.build_reminder cycles }
    let(:user) { build :user, last_submission_date: cycles.weeks.ago }
    let(:cycles) { 1 }

    it "renders the headers" do
      expect(reminder.subject).to eq("We miss you!")
      expect(reminder.to).to eq([user.email])
      expect(reminder.from).to eq(["support@mumuki.org"])
    end

    context "this week" do
      let(:cycles) { 0 }

      it { expect(user.should_send_reminder? cycles).to be false }
    end

    context "after 1 week" do
      it { expect(user.should_send_reminder? cycles).to be true }
      it { expect(reminder.body.encoded).to match("Hi") }
    end

    context "after 2 weeks" do
      let(:cycles) { 2 }

      it { expect(user.should_send_reminder? cycles).to be true }
      it { expect(reminder.body.encoded).to match("Hi") }
    end

    context "after 3 weeks" do
      let(:cycles) { 3 }

      it { expect(user.should_send_reminder? cycles).to be true }
      it { expect(reminder.body.encoded).to match("Hi") }
    end

    context "after 4 weeks" do
      let(:cycles) { 4 }

      it { expect(user.should_send_reminder? cycles).to be false }
    end
  end
end
