require 'spec_helper'

describe Mumukit::Auth::LoginSettings do
  let(:defaults) { Mumukit::Auth::LoginSettings.defaults }
  let(:facebook_and_user_pass) { [Mumukit::Auth::LoginSettings.facebook, Mumukit::Auth::LoginSettings.user_pass] }

  describe '#social_methods' do
    context 'with few methods' do
      let(:mumukit) { Mumukit::Auth::LoginSettings.new(facebook_and_user_pass) }
      it { expect(mumukit.send(:social_methods)).to eq 1 }
      it { expect(mumukit.has_few_methods?).to eq true }
    end

    context 'with many methods' do
      let(:mumukit) { Mumukit::Auth::LoginSettings.new(defaults) }
      it { expect(mumukit.send(:social_methods)).to eq 4 }
      it { expect(mumukit.has_few_methods?).to eq false }
    end

  end

end
