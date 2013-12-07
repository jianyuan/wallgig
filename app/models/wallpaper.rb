# == Schema Information
#
# Table name: wallpapers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  purity       :string(255)
#  processing   :boolean          default(TRUE)
#  image        :string(255)
#  image_width  :integer
#  image_height :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Wallpaper < ActiveRecord::Base
  belongs_to :user

  extend Enumerize
  enumerize :purity, in: [:sfw, :sketchy, :nsfw], default: :sfw
end
