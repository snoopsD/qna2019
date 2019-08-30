class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at
  has_many :comments, as: :commentable
  has_many :files
  has_many :links do
    object.links.order(id: :asc)
  end
end
