# == Schema Information
#
# Table name: wallpapers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  purity              :string(255)
#  processing          :boolean          default(TRUE)
#  image_uid           :string(255)
#  image_name          :string(255)
#  image_width         :integer
#  image_height        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  standard_image_uid  :string(255)
#  large_image_uid     :string(255)
#  thumbnail_image_uid :string(255)
#

class Wallpaper < ActiveRecord::Base
  belongs_to :user

  # Purity
  extend Enumerize
  enumerize :purity, in: [:sfw, :sketchy, :nsfw], default: :sfw

  # Image
  attr_readonly :image

  dragonfly_accessor :image

  dragonfly_accessor :standard_image do
    storage_options do |i|
      { path: image_storage_path(i) }
    end
  end

  dragonfly_accessor :large_image do
    storage_options do |i|
      { path: image_storage_path(i) }
    end
  end

  dragonfly_accessor :thumbnail_image do
    storage_options do |i|
      { path: image_storage_path(i) }
    end
  end

  validates :image, presence: true
  validates_property :mime_type, of: :image, in: ['image/jpeg', 'image/png'], on: :create

  scope :processing, -> { where(processing: true ) }
  scope :processed, -> { where(processing: false) }
  scope :visible, -> { processed }

  after_create :queue_create_thumbnails
  after_save :update_processing_status, if: :processing?

  def queue_create_thumbnails
    WallpaperResizerWorker.perform_async(self.id)
  end

  def update_processing_status
    if has_image_sizes?
      self.processing = false
      save
    end
  end

  def has_image_sizes?
    standard_image.present? && large_image.present? && thumbnail_image.present?
  end

  def image_storage_path(i)
    name = File.basename(image_uid, (image.ext || '.jpg'))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join('/')
  end

end
