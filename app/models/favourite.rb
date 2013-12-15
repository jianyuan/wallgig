class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :wallpaper
  belongs_to :collection
end
