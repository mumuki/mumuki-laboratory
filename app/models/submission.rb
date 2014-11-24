class Submission < ActiveRecord::Base
  enum status: [:pending, :running, :passed, :failed]

  belongs_to :exercise
  validates_presence_of :exercise

  after_create do
    TestRunner.new.async.perform(id)
  end

  def language
    exercise.language
  end

  def compile
    _compile(exercise.test, content)
  end

  private

  def _compile(test_src, submission_src)
    <<EOF
import Test.Hspec
import Test.QuickCheck

#{submission_src}
main :: IO ()
main = hspec $ do
  #{test_src}
EOF
  end

end



