#!/usr/bin/env ruby
require 'dragonfly'

p0 = Photo.all[2]
p1 = Photo.all[4]

image = Photo.all[2].photo_image
image2 = Photo.all[4].photo_image

new_image = image2.process(:append, p0.id, p1.id)
result = `open #{new_image.thumb("30x40").path}`
while (true) do
end
