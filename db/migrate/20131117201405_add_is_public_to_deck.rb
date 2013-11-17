class AddIsPublicToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :is_public, :boolean, :defalut => false
    add_index :decks, [:is_public], :unique => true
  end
end
