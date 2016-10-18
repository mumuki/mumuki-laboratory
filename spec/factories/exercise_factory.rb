FactoryGirl.define do

  factory :language do
    sequence(:name) { |n| "lang#{n}" }

    runner_url { Faker::Internet.url }
    devicon { name }
    queriable true
  end

  factory :haskell, parent: :language do
    name 'haskell'
  end

  factory :gobstones, parent: :language do
    name 'gobstones'
    queriable false
  end

  factory :exercise_base do
    sequence(:bibliotheca_id) { |n| n }
    sequence(:number) { |n| n }

    language { guide ? guide.language : create(:language) }
    layout 'input_right'
    locale :en
    guide
  end

  factory :problem, class: Problem, parent: :exercise_base do
    name 'A problem'
    description 'Simple problem'
    test 'dont care'
  end

  factory :playground, class: Playground, parent: :exercise_base do
    name 'A Playground'
    description 'Simple playground'
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
