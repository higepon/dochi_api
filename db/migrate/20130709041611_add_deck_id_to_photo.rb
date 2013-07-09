class AddDeckIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :deck_id, :integer
  end
end
