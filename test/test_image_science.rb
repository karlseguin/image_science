dir = File.expand_path "~/.ruby_inline"
if test ?d, dir then
  require 'fileutils'
  puts "nuking #{dir}"
  # force removal, Windoze is bitching at me, something to hunt later...
  FileUtils.rm_r dir, :force => true
end

require 'rubygems'
require 'minitest/unit'
require 'minitest/autorun' if $0 == __FILE__
require 'image_science'

MiniTest::Unit.autorun

class TestImageScience < MiniTest::Unit::TestCase
#class TestImageScience < Test::Unit::TestCase
  def setup
    @pix = 'test/pix.png'               # 50 x 50
    @bearry = 'test/bearry.png'         # 323 x 24
    @biggie = 'test/biggie.png'         # 800 x 600
    @godzilla = 'test/godzilla.png'     # 300 x 399
    @landscape = 'test/landscape.png'   # 400 x 300
    @portrait = 'test/portrait.png'     # 300 x 500
    @tmppath = 'test/tmp.png'
    @h = @w = 50
  end

  def teardown
    File.unlink @tmppath if File.exist? @tmppath
  end

  def test_class_with_image
    ImageScience.with_image @pix do |img|
      assert_kind_of ImageScience, img
      assert_equal @h, img.height
      assert_equal @w, img.width
      assert img.save(@tmppath)
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert_equal @h, img.height
      assert_equal @w, img.width
    end
  end

  def test_class_with_image_missing
    assert_raises TypeError do
      ImageScience.with_image @pix + "nope" do |img|
        flunk
      end
    end
  end

  ##
  # the assert_raises RuntimeError is not working on our setup don't have time
  # to investigate right now. TODO: figure out why
  
  def test_class_with_image_missing_with_img_extension

    assert_raises RuntimeError do
      assert_nil ImageScience.with_image("nope#{@pix}") do |img|
        flunk
      end
    end
  end

  def test_class_with_image_from_memory
    data = File.new(@pix).binmode.read

    ImageScience.with_image_from_memory data do |img|
      assert_kind_of ImageScience, img
      assert_equal @h, img.height
      assert_equal @w, img.width
      assert img.save(@tmppath)
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert_equal @h, img.height
      assert_equal @w, img.width
    end
  end

  def test_class_with_image_from_memory_empty_string
    assert_raises TypeError do
      ImageScience.with_image_from_memory "" do |img|
        flunk
      end
    end
  end

  def test_resize
    ImageScience.with_image @pix do |img|
      img.resize(25, 25) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert_equal 25, img.height
      assert_equal 25, img.width
    end
  end

  def test_buffer_return
    ImageScience.with_image @pix do |img|
      img.resize(25, 25) do |thumb|
#        assert thumb.buffer('.jpg')
        thumb.buffer('.jpg') do |buffer|
          assert buffer
        end
      end
    end
  end

  def test_buffer_yield
    ImageScience.with_image @pix do |img|
      img.resize(25, 25) do |thumb|
        thumb.buffer('.jpg') do |buffer|
          assert buffer
        end
      end
    end
  end

  def test_resize_floats
    ImageScience.with_image @pix do |img|
      img.resize(25.2, 25.7) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert_equal 25, img.height
      assert_equal 25, img.width
    end
  end

  def test_resize_zero
    assert_raises ArgumentError do
      ImageScience.with_image @pix do |img|
        img.resize(0, 25) do |thumb|
          assert thumb.save(@tmppath)
        end
      end
    end

    refute File.exists?(@tmppath)

    assert_raises ArgumentError do
      ImageScience.with_image @pix do |img|
        img.resize(25, 0) do |thumb|
          assert thumb.save(@tmppath)
        end
      end
    end

    refute File.exists?(@tmppath)
  end

  def test_resize_negative
    assert_raises ArgumentError do
      ImageScience.with_image @pix do |img|
        img.resize(-25, 25) do |thumb|
          assert thumb.save(@tmppath)
        end
      end
    end

    refute File.exists?(@tmppath)

    assert_raises ArgumentError do
      ImageScience.with_image @pix do |img|
        img.resize(25, -25) do |thumb|
          assert thumb.save(@tmppath)
        end
      end
    end

    refute File.exists?(@tmppath)
  end

  ##
  # biggie.png is 800 x 600

  def test_fit_within_smaller
    ImageScience.with_image @biggie do |img|
      img.fit_within(100, 100) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert_equal 100, img.width
    end
  end

  def test_fit_within_shrinking_x
    max_x = 44
    max_y = 111

    ImageScience.with_image @pix do |img|
      img.fit_within(max_x, max_y) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert img.height <= 50
      assert img.width <= max_x
    end
  end

  def test_fit_within_shrinking_y
    max_x = 100
    max_y = 40

    ImageScience.with_image @pix do |img|
      img.fit_within(max_x, max_y) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert img.height <= max_y
      assert img.width <= 50
    end
  end

  def test_fit_within_shrinking_both
    max_x = 33
    max_y = 44

    ImageScience.with_image @pix do |img|
      img.fit_within(max_x, max_y) do |thumb|
        assert thumb.save(@tmppath)
      end
    end

    assert File.exists?(@tmppath)

    ImageScience.with_image @tmppath do |img|
      assert_kind_of ImageScience, img
      assert img.height <= max_y
      assert img.width <= max_x
    end
  end

  def test_fit_withins

    max_x = max_y = 77
    original_x = original_y = 9999

    [@pix, @biggie, @bearry, @landscape, @portrait].each { |image_name|

      ImageScience.with_image image_name do |img|
        original_x = img.width
        original_y = img.height
        img.fit_within(max_x, max_y) do |thumb|
          assert thumb.save(@tmppath)
        end
      end

      assert File.exists?(@tmppath)

      ImageScience.with_image @tmppath do |img|
        assert_kind_of ImageScience, img
        assert img.height <= max_y
        assert img.width <= max_x
        assert img.height <= original_y
        assert img.width <= original_x
      end
    }
  end

  def test_thumbnailing

    max = 77
    original_x = original_y = 9999

    [@pix, @biggie, @bearry, @landscape, @portrait].each { |image_name|

      ImageScience.with_image image_name do |img|
        original_x = img.width
        original_y = img.height
        img.thumbnail(max) do |thumb|
          assert thumb.save(@tmppath)
        end
      end

      assert File.exists?(@tmppath)

      ImageScience.with_image @tmppath do |img|
        assert_kind_of ImageScience, img
        assert img.height <= max
        assert img.width <= max
      end
    }
  end

  def test_resize_with_crop
    images  = [@pix, @bearry, @biggie, @godzilla, @landscape, @portrait]
    heights = [50, 450]
    widths  = [80, 725]
    images.each do |image_file|
      ImageScience.with_image(image_file) do |img|
        heights.each_with_index do |height, index|
          width = widths[index]
          img.resize_with_crop(width, height) do |resized_image|
            assert(resized_image.nil? == false)
            assert_equal(height, resized_image.height)
            assert_equal(width, resized_image.width)
          end
        end
      end
    end
  end

end
