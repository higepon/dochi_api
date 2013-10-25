require 'dragonfly/rails/images'
require 'pp'
require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => 'dochi',
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    )
  end
end

include Dragonfly::ImageMagick::Utils

app.processor.add :append do |temp_object, *args|
  tempfile = new_tempfile(nil)
  
  # When we pass photo_image directly, it causes cyclic reference error.
  # So we fetch images again here :(
  p0 = Photo.find(args[0]).photo_image
  p1 = Photo.find(args[1]).photo_image
  result = `convert +append #{quote(p0.path)} #{quote(p1.path)} #{quote(tempfile.path)}`

  # if fail, just return image0
  if $?.exitstatus == 1 || !$?.success?
    p0
  else
    tempfile
  end
end

app.define_macro(ActiveRecord::Base, :image_accessor)
