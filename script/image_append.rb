#!/usr/bin/env ruby
require 'dragonfly'

p0 = Photo.all[2]
p1 = Photo.all[4]

image = Photo.all[2].photo_image
image2 = Photo.all[4].photo_image

# うまくうごかず convert コマンドがなんにも言わない場合がある
# file exist で確認すべき
new_image = image2.process(:append, nil, p0.id, p1.id)
puts "HH"
    puts `ls -la #{new_image.path}`
result = `open #{new_image.thumb("30x40").path}`
puts new_image.url
puts new_image.thumb("30x40").path
while (true) do
end
# module Dragonfly
#   module ImageMagick
#     class Processor
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
#   end
# end

# h = Dragonfly::ImageMagick::Processor.new
# puts h.c(Photo.first.photo_image.path, Photo.first.photo_image.path)

# class MyProxy
#   include Dragonfly::Shell
#   def path
#     "-append #{Photo.first.photo_image.path} #{Photo.first.photo_image.path}"
#   end
# end

# Dragonfly::app.config.processor.register(ImageMagick::Processor)
# image2 = Photo.all[1].photo_image
# puts image1.raw_identify("-append", image1.path, image2.path).path

#Dragonfly::ImageMagick::Utils.run convert_command, MyProxy.new

#Dragonfly::ImageMagick.hoge(Photo.first.photo_image.path, Photo.first.photo_image.path)
