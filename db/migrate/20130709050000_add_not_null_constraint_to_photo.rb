class AddNotNullConstraintToPhoto < ActiveRecord::Migration
  def change
    change_column :photos, :deck_id, :integer, :null => false
  end
end
