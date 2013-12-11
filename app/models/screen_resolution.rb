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

  alias to_param to_s
end
