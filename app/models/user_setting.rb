# == Schema Information
#
# Table name: user_settings
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  sfw                  :boolean          default(TRUE)
#  sketchy              :boolean          default(FALSE)
#  nsfw                 :boolean          default(FALSE)
#  per_page             :integer          default(20)
#  infinite_scroll      :boolean          default(TRUE)
#  screen_width         :integer
#  screen_height        :integer
#  created_at           :datetime
#  updated_at           :datetime
#  screen_resolution_id :integer
#

class UserSetting < ActiveRecord::Base
  belongs_to :user
  belongs_to :screen_resolution

  extend Enumerize
  enumerize :per_page, in: [20, 40, 60], default: 20

  before_save :set_screen_resolution, if: proc { |s| s.screen_width_changed? || s.screen_height_changed? }

  def purities
    out = []
    out << 'sfw'     if sfw?
    out << 'sketchy' if sketchy?
    out << 'nsfw'    if nsfw?
    out
  end

  def set_screen_resolution
    if screen_width.present? && screen_height.present?
      self.screen_resolution = ScreenResolution.where(width: screen_width, height: screen_height).first
    else
      self.screen_resolution = nil
    end
  end

  def needs_screen_resolution?
    screen_width.blank? || screen_height.blank?
  end
end
