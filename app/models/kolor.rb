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

  has_many :wallpaper_colors, foreign_key: 'color_id', dependent: :destroy
  has_many :wallpapers, through: :wallpaper_colors, foreign_key: 'color_id'

  scope :near_to, ->(hex) {
    color = Color::RGB.from_html(hex) rescue nil
    if color
      select("colors.*, (abs(#{color.red} - red) + abs(#{color.green} - green) + abs(#{color.blue} - blue)) / 3 AS difference")
        .order('difference ASC')
        .where("(abs(#{color.red} - red) + abs(#{color.green} - green) + abs(#{color.blue} - blue)) / 3 < 15")
    end
  }

  def self.find_or_create_by_color(color)
    find_or_create_by(hex: color.html[1..-1], red: color.red, green: color.green, blue: color.blue)
  end

  def to_html_hex
    "\##{hex}" if hex.present?
  end
end