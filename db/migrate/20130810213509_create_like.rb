class CreateLike < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.integer :photo_id
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :likes
  end
end
