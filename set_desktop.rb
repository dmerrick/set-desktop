#!/usr/bin/env ruby -wKU

class SetDesktop

  def initialize
    @desktop_image = "./test_file.gif"
  end

  def create_image_from_DATA
    image_data = DATA.read
    new_file = File.new(@desktop_image,"w+")
    new_file.write(image_data)
  end
end

if $0 == __FILE__
  desk = SetDesktop.new

  desk.create_image_from_DATA
end

__END__
GIF87a  �     ���   �� �  ��  �      �� �                  ,       �� ;
