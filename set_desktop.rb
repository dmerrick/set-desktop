#!/usr/bin/env ruby -wKU
# This program is used to set the background on a computer running OS X.
# The tricky thing is that it saves the desired image inside the script itself.
#
# This is useful for pranking your friends who leave their computers unprotected
# insofar as you could run something like:
#
# curl http://http://your.server.com/this_script.rb | ruby
#
# To quickly set the background to whatever you'd like to make them look at.
#
# === Changing the saved image
# To change the image stored in this file, simply run this script on your 
# computer with the filename as an argument. It can even be a URL!
# 
# For instance:
# set_desktop.rb ~/Downloads/funny.png
# set_desktop.rb http://farm1.static.flickr.com/4/6532650_7c255cbbd8_o_d.jpg
#
# === Using a screenshot
# To quickly recreate an old computer prank, you can choose to use a screenshot
# instead of a stored image. Once you do, you can hide all of their windows
# and watch them try to figure out why nothing is reponding to their clicks.
#
# To do this, use the #create_image_from_screenshot method.
#
# === Changing the login image
# To be even more devious, you can use this program to change the image on the
# OS X login screen. They won't notice til they reboot, and most people don't
# know how to change it back!
#
# To do this, use the #set_login_image! method.
#
# Author:: Dana Merrick (mailto:letterkills+setdesktop@gmail.com)
# Copyright:: Copyright (c) 2009 Dana Merrick
# License:: Released under the MIT license

class SetDesktop

  attr_writer :desktop_image

  # Constructor simply sets the default filename.
  def initialize
    @desktop_image = "/tmp/wallpaper.gif"
  end

  # This method sets the login background to the specified image.
  #--
  # TODO: undo_set_login_background method? :)
  def set_login_background!
    `defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture "#{File.expand_path(@desktop_image)}"`
  end

  # This method sets the desktop background to the specified image.
  def set_desktop_background!
    command = <<-EOF 
    /usr/bin/osascript -e 'tell application "Finder"
    set desktop picture to POSIX file "#{File.expand_path(@desktop_image)}"
    end tell'
    EOF
    `#{command}`
  end

  # This reads the image data from the DATA block at the end of the file.
  # Image data is added either by using the #load_new_image! method, or it
  # can be done by manually editing the file.
  #--
  # TODO: sanity checks on the data?
  def create_image_from_DATA
    puts "Creating file at " + @desktop_image
    image_data = DATA.read
    new_file = File.new(@desktop_image,"w+")
    new_file.write(image_data)
  end

  # Uses the file command to check the file extension. Not currently used.
  def check_file_type
    `file #{@desktop_image}`.sub(/^.*: /,'').split.first.downcase
  end

  # Takes a screenshot and uses that as the image.
  #--
  # TODO: Does the Terminal window get captured here? That could be a problem.
  def create_image_from_screenshot
    type = @desktop_image.split(/\./).last
    `screencapture -t#{type} -x #@desktop_image`
  end

  # Reads a new image from a the hard drive or a URL and appends it to the end
  # of the script.
  def self.load_new_image!(location)

    if location =~ /^http:\/\//
      command = "curl "
      file_data = File.popen(command + location).read
    else
      file_data = File.read(location)
    end

    File.open(__FILE__,File::RDWR) do |file|
      # look through the file for the DATA section
      file.each_line do |line|
        break if line =~ /^__END__$/
      end
      # TODO: clear out everything below DATA first
      file.puts(file_data)
    end
  end
end

if $0 == __FILE__

  # change the image if provided
  unless ARGV.empty?
    SetDesktop.load_new_image!(ARGV.last)
    exit
  end

  desk = SetDesktop.new

  desk.desktop_image = "./test_file.png"

  desk.create_image_from_DATA
  #desk.create_image_from_screenshot

  desk.set_desktop_background!
  #desk.set_login_background!
  
end

# image file data goes below the next line
__END__
