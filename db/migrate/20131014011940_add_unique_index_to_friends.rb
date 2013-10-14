class AddUniqueIndexToFriends < ActiveRecord::Migration
  def change
    add_index :friends, [:src_user_id, :dest_user_id], :unique => true
  end
end
