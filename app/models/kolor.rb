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

  validates_presence_of :red
  validates_presence_of :green
  validates_presence_of :blue
  validates_presence_of :hex

  def self.find_or_create_by_color(color)
    find_or_create_by(hex: color.html[1..-1], red: color.red, green: color.green, blue: color.blue)
  end

  def to_html_hex
    "\##{hex}" if hex.present?
  end
end