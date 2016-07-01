require 'spec_helper'

describe Mumukit::Auth::LoginMethods do
  let(:defaults) { Mumukit::Auth::LoginMethods.defaults }
  let(:facebook_and_user_pass) { [Mumukit::Auth::LoginMethods.facebook, Mumukit::Auth::LoginMethods.user_pass] }

  describe '#social_methods' do
    context 'with few methods' do
      let(:mumukit) { Mumukit::Auth::LoginMethods.new(facebook_and_user_pass) }
      it { expect(mumukit.send(:social_methods)).to eq 1 }
      it { expect(mumukit.has_few_methods?).to eq true }
    end

    context 'with many methods' do
      let(:mumukit) { Mumukit::Auth::LoginMethods.new(defaults) }
      it { expect(mumukit.send(:social_methods)).to eq 4 }
      it { expect(mumukit.has_few_methods?).to eq false }
    end

  end

end
