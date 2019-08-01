class AddBadgeToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :badges, :answer, foreign_key: true
  end
end
