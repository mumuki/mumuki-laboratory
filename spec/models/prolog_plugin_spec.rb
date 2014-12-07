require 'spec_helper'

describe PrologPlugin do
  describe '#run_command' do
    let(:file) { OpenStruct.new(path: '/tmp/foo.pl') }
    let(:plugin) { PrologPlugin.new }

    it { expect(plugin.run_command(file)).to include('swipl -f /tmp/foo.pl --quiet -t run_tests') }
    it { expect(plugin.run_command(file)).to include('2>&1') }
  end
end
