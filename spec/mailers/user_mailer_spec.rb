require "spec_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "we_miss_you_notification" do
    let(:user) { build :user }
    let(:mail) { UserMailer.we_miss_you_notification(user, 1) }

    it "renders the headers" do
      expect(mail.subject).to eq("We miss you!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["support@mumuki.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
