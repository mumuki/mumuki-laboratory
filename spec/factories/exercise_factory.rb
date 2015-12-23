FactoryGirl.define do

  factory :language do
    sequence(:name) {|n| "lang#{n}"}

    test_runner_url { Faker::Internet.url }
    devicon { name }
    queriable true
  end

  factory :haskell, parent: :language do
    name 'haskell'
  end


  factory :problem do
    name 'A problem'
    description 'Simple problem'
    language { guide ? guide.language : create(:language) }
    test 'dont care'
    locale :en
    position 1
    guide
  end

  factory :playground do
    name 'A Playground'
    description 'Simple playground'
    language { guide ? guide.language : create(:language) }
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
