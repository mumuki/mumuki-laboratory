class HaskellPlugin < BasePlugin

  def run_test_command(file)
    "runhaskell #{file.path} 2>&1"
  end

  def compile(test_src, submission_src)
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
