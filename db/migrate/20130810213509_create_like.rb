class CreateLike < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.integer :photo_id
      t.integer :user_id
      t.timestamps
    end
    add_index :likes, [:photo_id, :user_id], :unique => true
  end

  def down
    drop_table :likes
  end
end
