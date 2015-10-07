FactoryGirl.define do

  factory :language do
    sequence(:name) {|n| "lang#{n}"}
    sequence(:extension) {|n| "ext#{n}"}

    test_runner_url { Faker::Internet.url }
    image_url { Faker::Internet.url }
    queriable true
  end

  factory :haskell, parent: :language do
    extension 'hs'
    name 'haskell'
  end


  factory :problem do
    name 'A problem'
    description 'Simple problem'
    language { guide ? guide.language : create(:language) }
    test 'dont care'
    author { create(:user) }
    locale :en
    position 1
  end

  factory :playground do
    name 'A Playground'
    description 'Simple playground'
    language { guide ? guide.language : create(:language) }
    author { create(:user) }
    locale :en
  end

  factory :exercise, parent: :problem

  factory :x_equal_5_exercise, parent: :exercise do
    test <<-EOT
          describe "x" $ do
            it "should be equal 5" $ do
               x `shouldBe` 5
    EOT
  end
end
