class HaskellPlugin

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