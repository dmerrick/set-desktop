#!/usr/bin/env ruby -wKU

class SetDesktop

  attr_writer :desktop_image

  def initialize
    # default file name
    @desktop_image = "/tmp/wallpaper.gif"
  end

  def create_image_from_DATA
    image_data = DATA.read
    new_file = File.new(@desktop_image,"w+")
    new_file.write(image_data)
  end

  def create_image_from_screenshot
    `screencapture -tgif -x #{@desktop_image}`
  end

  def load_new_image(location)
    # file:///Users/dmerrick/other_projects/set-desktop/orange.gif
  end
end

if $0 == __FILE__
  desk = SetDesktop.new

  desk.desktop_image = "./test_file.gif"

  desk.create_image_from_DATA
  #desk.create_image_from_screenshot
end

# image file data goes below the next line
__END__
GIF87a  �     ���   �� �  ��  �      �� �                  ,       �� ;
