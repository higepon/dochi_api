class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :src_user_id
      t.integer :dest_user_id
      t.timestamps
    end
  end
end
