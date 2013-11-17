class RemoveIsPublicUniq < ActiveRecord::Migration
  def up
    remove_index :decks, [:is_public]
    add_index :decks, [:is_public], :unique => false
  end

  def down
  end
end
