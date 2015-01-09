require 'spec_helper'

describe ImportLog do
  let(:log) { ImportLog.new }

  before do
    log.no_description('isEven')
    log.no_meta('isEven')
    log.no_lang('isOdd')
  end

  it { expect(log.to_s).to eq 'Description does not exist for isEven, Meta does not exist for isEven, Language not found for isOdd' }
end
