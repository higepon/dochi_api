class AddUrlKeyToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :url_key, :string
    add_index :decks, [:url_key], :unique => true
  end
end
