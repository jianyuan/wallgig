# == Schema Information
#
# Table name: colors
#
#  id    :integer          not null, primary key
#  red   :integer
#  green :integer
#  blue  :integer
#  hex   :string(255)
#

class Color < ActiveRecord::Base
  has_many :wallpaper_colors
  has_many :wallpapers, through: :wallpaper_colors
end
