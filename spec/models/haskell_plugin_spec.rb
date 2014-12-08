require 'spec_helper'

describe HaskellPlugin do

  true_test = <<EOT
describe "x" $ do
   it "should be True" $ do
     x `shouldBe` True
EOT

  submissions_content = <<EOC
x = True
EOC

  compiled_true_test_submission = <<EOT
import Test.Hspec
import Test.QuickCheck

x = True

main :: IO ()
main = hspec $ do
describe "x" $ do
   it "should be True" $ do
     x `shouldBe` True

EOT


  let(:plugin) { HaskellPlugin.new }

  describe '#run_command' do
    let(:file) { OpenStruct.new(path: '/tmp/foo.hs') }

    it { expect(plugin.run_test_command(file)).to include('runhaskell /tmp/foo.hs') }
    it { expect(plugin.run_test_command(file)).to include('2>&1') }
  end

  describe '#compile' do
    let(:exercise) { create :exercise, test: true_test }
    let(:submission) { exercise.submissions.create content: submissions_content }

    it { expect(submission.compile_with(plugin)).to eq(compiled_true_test_submission) }
  end

end
