FactoryBot.define do
  factory :answer do
    body { "AnswerBody" }
    user

    trait :invalid do
      body { nil }
    end  
  end
end
