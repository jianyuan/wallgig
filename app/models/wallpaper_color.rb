# == Schema Information
#
# Table name: wallpaper_colors
#
#  id           :integer          not null, primary key
#  wallpaper_id :integer
#  color_id     :integer
#  percentage   :float
#

class WallpaperColor < ActiveRecord::Base
  belongs_to :wallpaper
  belongs_to :color, class_name: 'Kolor'

  delegate :hex, to: :color
end
