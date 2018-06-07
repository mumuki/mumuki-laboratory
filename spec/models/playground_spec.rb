require 'spec_helper'

describe Playground do
  let(:user) { create(:user) }

  describe '#create' do
    context 'when language is queriable and exercise is playable' do
      let(:language) { create(:language, queriable: true) }
      let(:guide) { create(:guide) }
      let(:exercise) { build(:playground, language: language, layout: :input_bottom, guide: guide, number: 1) }

      it { expect(exercise.save).to be true }
    end

    context 'when language is not queriable and exercise is playable' do
      let(:language) { create(:language, queriable: false) }
      let(:exercise) { build(:playground, language: language, layout: :input_bottom) }

      it { expect(exercise.save).to be false }
    end
  end

end
