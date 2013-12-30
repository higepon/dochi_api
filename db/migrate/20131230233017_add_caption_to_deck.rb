class AddCaptionToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :caption, :string, :defalut => ""
  end
end
