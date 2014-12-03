require 'spec_helper'

describe User do

  describe '#perform' do
    let(:exercise) {
      Exercise.create!(
          title: 'Exercise 1',
          description: 'Simple exercise',
          language: :haskell,
          test: <<-EOT
          describe "x" $ do
            it "should be equal 5" $ do
               x `shouldBe` 5
      EOT
      ) }
    before { TestRunner.new.perform(submission.id) }

    context 'when submission is ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to equal(:passed) }
      it { expect(submission.reload.result.to equal('TODO')) }
    end

    context 'when submission is not ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to equal(:failed) }
      it { expect(submission.reload.result.to equal('TODO')) }
    end

  end
end
