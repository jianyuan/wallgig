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

  default_scope -> { order("case when category = 'widescreen' then 1 else 2 end ASC, width DESC, height DESC") }

  def to_s
    "#{width}&times;#{height}".html_safe
  end

  def wallpapers
    Wallpaper.where(image_width: width, image_height: height)
  end

end