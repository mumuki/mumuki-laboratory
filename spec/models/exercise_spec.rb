require 'spec_helper'

describe Exercise do
  describe '#default_content_for' do
    let(:user) { create(:user) }
    let(:exercise) { create(:exercise) }

    context 'when user has a single submission for the exercise' do
      let!(:submission) { exercise.submissions.create!(submitter: user, content: 'foo') }

      it { expect(exercise.default_content_for(user)).to eq submission.content }
    end

    context 'when user has no submissions for the exercise' do
      it { expect(exercise.default_content_for(user)).to eq '' }
    end


    context 'when user has multiple submission for the exercise' do
      let!(:submissions) { [exercise.submissions.create!(submitter: user, content: 'foo'),
                            exercise.submissions.create!(submitter: user, content: 'bar')] }

      it { expect(exercise.default_content_for(user)).to eq submissions.last.content }
    end
  end

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
