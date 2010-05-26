= ImageScience

* http://github.com/g1nn13/image_science
* http://seattlerb.rubyforge.org/ImageScience.html
* http://rubyforge.org/projects/seattlerb

== DESCRIPTION:

g1nn13 fork changes:

* added buffer() method to get image buffer for writing (to Amazon S3)
* added fit_within() method to resize an image to fit within a specified
  height and width without changing the image's aspect ratio
* added resize_with_crop() to resize and crop images where the
  target aspect ratio differs from the original aspect ratio. This is
  for converting portrait to landscape and landscape to portrait.



ImageScience is a clean and happy Ruby library that generates
thumbnails -- and kicks the living crap out of RMagick. Oh, and it
doesn't leak memory like a sieve. :)

For more information including build steps, see http://seattlerb.rubyforge.org/

== FEATURES/PROBLEMS:

* Glorious graphics manipulation magi... errr, SCIENCE! in less than 200 LoC!
* Supports square and proportional thumbnails, as well as arbitrary resizes.
* Pretty much any graphics format you could want. No really.
* see g1nn13 fork changes above

== SYNOPSYS:

  ImageScience.with_image(file) do |img|
    img.cropped_thumbnail(100) do |thumb|
      thumb.save "#{file}_cropped.png"
    end

    img.thumbnail(100) do |thumb|
      thumb.save "#{file}_thumb.png"
    end
  end

== REQUIREMENTS:

* FreeImage
* ImageScience

== INSTALL:

* Download and install FreeImage. See notes at url above.
* sudo gem install -y g1nn13-image_science
* see http://seattlerb.rubyforge.org/ImageScience.html for more info.

== LICENSE:

(The MIT License)

Copyright (c) 2010 colin steele & jim nist, hotelicopter.com
Copyright (c) 2006-2009 Ryan Davis, Seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
