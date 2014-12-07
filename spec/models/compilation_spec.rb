require 'spec_helper'

describe Compilation do
  describe '#create_compilation_file!' do
    let(:submission) { create(:exercise).submissions.create! }
    let(:file) { submission.create_compilation_file!('x = 2') }

    it { expect(File.exists? file.path).to be_true }
  end
end
