FactoryGirl.define do

  factory :exercise do
    title 'Exercise 1'
    description 'Simple exercise'
    language :haskell
    test 'dont care'
    author { create(:user) }
  end

  factory :x_equal_5_exercise, parent: :exercise do
    test <<-EOT
          describe "x" $ do
            it "should be equal 5" $ do
               x `shouldBe` 5
    EOT
  end
end