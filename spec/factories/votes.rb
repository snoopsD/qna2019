FactoryBot.define do
  factory :vote do
    score { 1 }

    factory :negative_vote do
      score { -1 }
    end
  end
end
