require 'spec_helper'

describe Exercise do
  describe '#plugin' do
    let(:hs_exercise) { create(:exercise) }
    let(:pl_exercise) { create(:exercise, language: :prolog) }
    it { expect(hs_exercise.plugin.class).to equal(HaskellPlugin) }
    it { expect(pl_exercise.plugin.class).to equal(PrologPlugin) }
  end
end
