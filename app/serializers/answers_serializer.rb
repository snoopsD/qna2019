class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at
  belongs_to :user
end
