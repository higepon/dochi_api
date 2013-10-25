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

class MyProcessor

  def two(temp_object, opts={})
    puts "two"
  end


  private

  def my_helper_method
    # do stuff
  end

end

include Dragonfly::ImageMagick::Utils

app.processor.add :watermark do |temp_object, *args|
begin
  # If exact same path, unknown stack overflow is issued in Shell.rb around "if log_commands"
  if false #temp_object.path == args[0].path
    temp_object
  else
  pp args
  # use temp_object.data, temp_object.path, temp_object.file, etc.
#  app.configure {|c| c.log_commands = false }
  tempfile = new_tempfile(nil)
#    puts `ls -la #{tempfile.path}`
#  puts "convert -background blue +append #{quote(temp_object.path)} #{quote(args[0].path)} #{quote(tempfile.path)}"
  #run "convert","+append #{quote(temp_object.path)} #{quote(args[0].path)} #{quote(tempfile.path)}"

    p0 = Photo.find(args[1]).photo_image
    p1 = Photo.find(args[2]).photo_image
    puts "p0 = #{p0} p1=#{p1}"
    result = `convert -background blue +append #{quote(p0.path)} #{quote(p1.path)} #{quote(tempfile.path)}`
#    result = `convert -background blue +append #{quote(temp_object.path)} #{quote(args[0].path)} #{quote(tempfile.path)}`
    puts `ls -la #{tempfile.path}`
    pp $?.exitstatus
  tempfile
  end
  rescue => e
  STDERR.puts("ERRR=#{e}")
  # return a String, Pathname, File or Tempfile
end
end

#app.processor.register(MyProcessor)

# # module Dragonfly
# #   module ImageMagick
#     class Processor2
#       # include Configurable
#       # include Shell

#       def new_tempfile(ext=nil)
#         tempfile = ext ? Tempfile.new(['dragonfly', ".#{ext}"]) : Tempfile.new('dragonfly')
#         tempfile.binmode
#         tempfile.close
#         tempfile
#       end


#       def convert(path1, path2)
#         tempfile = new_tempfile(nil)
#         puts "convert","#{path1} -append #{path2} #{quote(tempfile.path)}"
#         run "convert"," +append #{path1} #{path2} hoge.jpg"
#         tempfile
#         puts "hoge called" 
#       end
     
#       def c(path1, path2)
#         convert(path1, path2)
#       end
#     end
# #  end
# #end


# app.configure do |c|
#   c.processor.register(Processor2)
# end

app.define_macro(ActiveRecord::Base, :image_accessor)
