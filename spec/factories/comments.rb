FactoryBot.define do
  factory :comment do
    body { "MyString" }
    for_question

    trait :for_question do
      association(:commentable, factory: :question)
    end
  end
end
