FactoryGirl.define do

  factory :language do
    sequence(:name) {|n| "lang#{n}"}
    sequence(:extension) {|n| "ext#{n}"}

    test_runner_url { Faker::Internet.url }
    image_url { Faker::Internet.url }
  end

  factory :haskell, parent: :language do
    extension 'hs'
    name 'haskell'
  end

  factory :exercise do
    title 'Exercise 1'
    description 'Simple exercise'
    language
    test 'dont care'
    author { create(:user) }
    locale :en
  end

  factory :x_equal_5_exercise, parent: :exercise do
    test <<-EOT
          describe "x" $ do
            it "should be equal 5" $ do
               x `shouldBe` 5
    EOT
  end
end
