# == Schema Information
#
# Table name: screen_resolutions
#
#  id       :integer          not null, primary key
#  width    :integer
#  height   :integer
#  category :string(255)
#

class ScreenResolution < ActiveRecord::Base
  extend Enumerize
  enumerize :category, in: [:standard, :widescreen]

  def to_s
    "#{width}x#{height}"
  end

  def wallpapers
    Wallpaper.where(image_width: width, image_height: height)
  end

end