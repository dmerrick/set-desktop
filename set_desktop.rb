#!/usr/bin/env ruby -wKU

class SetDesktop
  def create_image_from_DATA
    p DATA.readlines
  end
end

if $0 == __FILE__
  desk = SetDesktop.new

  desk.create_image_from_DATA
end

__END__
data!
various data!
