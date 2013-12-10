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
#  primary_color_id    :integer
#

class Wallpaper < ActiveRecord::Base
  belongs_to :user
  has_many :wallpaper_colors, -> { order(percentage: :desc) }, dependent: :destroy
  has_many :colors, through: :wallpaper_colors, class_name: 'Kolor'
  belongs_to :primary_color, class_name: 'Kolor'

  # Purity
  extend Enumerize
  enumerize :purity, in: [:sfw, :sketchy, :nsfw], default: :sfw, scope: true

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
  scope :near_to_color, ->(color) {
    color_ids = Kolor.near_to(color).map(&:id)
    # where(primary_color_id: color_ids) # @todo improve color search algorithm
    joins(:colors)
      .select('wallpapers.*')
      .where(colors: { id: color_ids }).group('wallpapers.id')
  }

  after_create :queue_create_thumbnails
  after_create :queue_extract_dominant_colors
  after_save :update_processing_status, if: :processing?

  def image_storage_path(i)
    name = File.basename(image_uid, (image.ext || '.jpg'))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join('/')
  end

  def queue_create_thumbnails
    WallpaperResizerWorker.perform_async(self.id)
  end

  def queue_extract_dominant_colors
    WallpaperExtractDominantColorsWorker.perform_async(self.id)
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

  def extract_dominant_colors
    return unless image.present?
    dominant_colors = Miro::DominantColors.new(image.path)
    hexes = dominant_colors.to_hex
    rgbs = dominant_colors.to_rgb
    percentages = dominant_colors.by_percentage

    # clear any old colors
    self.primary_color = nil
    wallpaper_colors.clear

    hexes.each_with_index do |hex, i|
      hex = hex[1..-1]
      color = Kolor.find_or_create_by(hex: hex, red: rgbs[i][0], green: rgbs[i][1], blue: rgbs[i][2])
      self.primary_color = color if i == 0
      self.wallpaper_colors.create color: color, percentage: percentages[i]
    end

    self.save
  end

  module ImageFormatMethods
    def format
      if image_height.nil? || image_width.nil?
        :unknown
      elsif image_height <= image_width
        :landscape
      else
        :portrait
      end
    end

    def portrait?
      format == :portrait
    end

    def landscape?
      format == :landscape
    end
  end

  include ImageFormatMethods

end
