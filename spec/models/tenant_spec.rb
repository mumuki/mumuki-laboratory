require 'spec_helper'

describe Book do
  describe '#on?' do
    it { expect(Book.on? 'test').to be true }
    it { expect(Book.on? 'foo').to be false }
  end
end