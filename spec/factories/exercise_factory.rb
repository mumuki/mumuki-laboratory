FactoryGirl.define do

  factory :language do
    name Faker::Lorem.word
    test_runner_url Faker::Internet.url
    extension Faker::Lorem.characters(3)
    image_url Faker::Internet.url
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
