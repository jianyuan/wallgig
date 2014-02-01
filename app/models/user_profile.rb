# == Schema Information
#
# Table name: user_profiles
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  cover_wallpaper_id       :integer
#  cover_wallpaper_y_offset :integer
#  country_code             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  username_color_hex       :string(255)
#  title                    :string(255)
#  avatar_uid               :string(255)
#

class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :cover_wallpaper, class_name: 'Wallpaper'

  dragonfly_accessor :avatar
  validates_size_of :avatar,     maximum: 5.megabytes
  validates_property :mime_type, of: :avatar, in: ['image/jpeg', 'image/png', 'image/gif']
  validates_property :width,     of: :avatar, in: (50..500)
  validates_property :height,    of: :avatar, in: (50..500)

  before_save :nilify_cover_wallpaper_y_offset, if: :cover_wallpaper_id_changed?

  def nilify_cover_wallpaper_y_offset
    self.cover_wallpaper_y_offset = nil
  end

  def cover_style
    styles = []
    if cover_wallpaper.present? && cover_wallpaper.sfw?
      styles << "background-image: url(#{cover_wallpaper.image.url})"
      styles << "background-position: center center"
    else
      styles << "background-image: url(http://placekitten.com/1920/450)"
      styles << "background-position: center center"
    end
    styles.join ';'
  end

  def username_color_hex=(value)
    write_attribute :username_color_hex, Kolor.normalize_html_hex(value).presence
  end

  def title=(value)
    write_attribute :title, value.presence
  end
end
