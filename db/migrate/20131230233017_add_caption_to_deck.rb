class AddCaptionToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :caption, :string, :defalut => nil
  end
end
