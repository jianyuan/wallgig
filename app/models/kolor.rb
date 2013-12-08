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

class Kolor < ActiveRecord::Base
  self.table_name = 'colors'

  has_many :wallpaper_colors, foreign_key: 'color_id'
  has_many :wallpapers, through: :wallpaper_colors, foreign_key: 'color_id'

  scope :near_to, ->(hex) {
    color = Color::RGB.from_html(hex) rescue nil
    if color
      select("colors.*, (abs(#{color.red} - red) + abs(#{color.green} - green) + abs(#{color.blue} - blue)) / 3 AS difference")
        .order('difference ASC')
        .where("(abs(#{color.red} - red) + abs(#{color.green} - green) + abs(#{color.blue} - blue)) / 3 < 15")
    end
  }
end
