#!/usr/bin/env ruby -wKU

class SetDesktop

  attr_writer :desktop_image

  def initialize
    # default file name
    @desktop_image = "/tmp/wallpaper.gif"
  end

  def set_login_background
    `defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture "#{@desktop_image}"`
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

    # TODO: clear out everything below DATA first

    command = "curl "

    File.open(__FILE__,File::RDWR) do |file|
      # look through the file for the DATA section
      file.each_line do |line|
        break if line =~ /^__END__$/
      end
      file.puts(File.popen(command + location).read)
    end
  end
end

if $0 == __FILE__
  desk = SetDesktop.new

  desk.desktop_image = "./test_file.gif"

  desk.create_image_from_DATA
  #desk.create_image_from_screenshot
  
  desk.load_new_image("file:///Users/dmerrick/other_projects/set-desktop/orange.gif")
end

# image file data goes below the next line
__END__
GIF87a  �     ���   �� �  ��  �      �� �                  ,       �� ;
