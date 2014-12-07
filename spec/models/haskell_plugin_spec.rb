require 'spec_helper'

describe HaskellPlugin do
  describe '#run_command' do
    let(:file) { OpenStruct.new(path: '/tmp/foo.pl') }
    let(:plugin) { HaskellPlugin.new }

    it { expect(plugin.run_test_command(file)).to include('runhaskell /tmp/foo.pl') }
    it { expect(plugin.run_test_command(file)).to include('2>&1') }
  end
end
