class AddUserIdToVote < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :votes, :user, index: true
  end
end
