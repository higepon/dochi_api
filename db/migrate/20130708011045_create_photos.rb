class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.string :photo_image_uid

      t.timestamps
    end
  end
end
