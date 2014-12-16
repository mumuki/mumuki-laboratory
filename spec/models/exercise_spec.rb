require 'spec_helper'

describe Exercise do
  describe '#plugin' do
    let(:hs_exercise) { create(:exercise) }
    let(:pl_exercise) { create(:exercise, language: :prolog) }
    it { expect(hs_exercise.plugin.class).to eq(HaskellPlugin) }
    it { expect(pl_exercise.plugin.class).to eq(PrologPlugin) }
  end

  describe '#by_tag' do
    let!(:tagged_exercise) { create(:exercise, tag_list: 'foo') }
    let!(:untagged_exercise) { create(:exercise) }

    it { expect(Exercise.by_tag('foo')).to include(tagged_exercise) }
    it { expect(Exercise.by_tag('foo')).to_not include(untagged_exercise) }

    it { expect(Exercise.by_tag('bar')).to_not include(tagged_exercise, untagged_exercise) }

    it { expect(Exercise.by_tag(nil)).to include(tagged_exercise, untagged_exercise) }
  end
end
