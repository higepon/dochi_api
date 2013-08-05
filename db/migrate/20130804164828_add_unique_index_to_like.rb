class AddUniqueIndexToLike < ActiveRecord::Migration
  def change
    add_index :likes, [:deck_id, :user_id], :unique => true
  end
end
