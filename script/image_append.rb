#!/usr/bin/env ruby
require 'dragonfly'

module Dragonfly
  module ImageMagick
    class Hoge
      include Configurable
      include Shell
      def hoge(path1, path2)
        puts "convert","#{path1} -append #{path2} hoge.jpg"
        run "convert"," +append #{path1} #{path2} hoge.jpg"
        puts "hoge called" 
      end
    end
  end
end

h = Dragonfly::ImageMagick::Hoge.new
h.hoge(Photo.first.photo_image.path, Photo.first.photo_image.path)
#Dragonfly::ImageMagick.hoge(Photo.first.photo_image.path, Photo.first.photo_image.path)
