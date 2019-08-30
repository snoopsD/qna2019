FactoryBot.define do
  factory :question do
    title { "QuestionTitle" }
    body { "QuestionBody" }
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
