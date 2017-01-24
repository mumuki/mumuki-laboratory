require 'spec_helper'

describe Mumukit::Login::Settings do
  let(:defaults) { Mumukit::Login::Settings.default_methods }
  let(:fresh_organization) { create(:organization, name: 'foo') }
  let(:facebook_and_user_pass) { [:facebook, :user_pass] }

  it { expect(fresh_organization.login_settings.login_methods).to eq defaults }
  it { expect(fresh_organization.login_settings.social_login_methods).to eq [] }
  it { expect(fresh_organization.login_settings.to_lock_json('/foo')).to be_html_safe }

  describe '#social_methods' do
    context 'with few methods' do
      let(:settings) { Mumukit::Login::Settings.new(facebook_and_user_pass) }
      it { expect(settings.social_login_methods.size).to eq 1 }
      it { expect(settings.many_methods?).to eq false }
    end

    context 'with many methods' do
      let(:settings) { build(:all_login_settings) }
      it { expect(settings.login_methods.size).to eq 5 }
      it { expect(settings.social_login_methods.size).to eq 4 }
      it { expect(settings.many_methods?).to eq true }
    end

    context 'without user_pass' do
      let(:settings) { Mumukit::Login::Settings.new([:facebook, :twitter]) }
      it { expect(settings.social_login_methods.size).to eq 2 }
      it { expect(settings.many_methods?).to eq false }
    end

  end

end
