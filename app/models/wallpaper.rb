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
#  thumbnail_image_uid :string(255)
#  primary_color_id    :integer
#  impressions_count   :integer          default(0)
#  cached_tag_list     :text
#  image_gravity       :string(255)
#  favourites_count    :integer          default(0)
#  purity_locked       :boolean          default(FALSE)
#  source              :string(255)
#

class Wallpaper < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :wallpaper_colors, -> { order('wallpaper_colors.percentage DESC') }, dependent: :destroy
  has_many :colors, through: :wallpaper_colors, class_name: 'Kolor'
  belongs_to :primary_color, class_name: 'Kolor'
  has_many :favourites, dependent: :destroy
  has_many :favourited_users, through: :favourites, source: :wallpaper

  # Purity
  extend Enumerize
  enumerize :purity, in: [:sfw, :sketchy, :nsfw], default: :sfw, scope: true
  enumerize :image_gravity, in: Dragonfly::ImageMagick::Processors::Thumb::GRAVITIES.keys

  # Image
  attr_readonly :image

  dragonfly_accessor :image

  dragonfly_accessor :thumbnail_image do
    storage_options do |i|
      { path: image_storage_path(i) }
    end
  end

  # Comments
  acts_as_commentable

  # Tags
  acts_as_taggable

  # Pagination
  paginates_per 20

  # Views
  is_impressionable counter_cache: true

  # Paper trail
  has_paper_trail only: [:purity, :cached_tag_list, :source]

  # Search
  include Tire::Model::Search
  tire.mapping do
    indexes :user_id,    type: 'integer', index: 'not_analyzed'
    indexes :user,       type: 'string',  index: 'not_analyzed'
    indexes :purity,     type: 'string',  index: 'not_analyzed'
    indexes :tags,       type: 'string',  analyzer: 'keyword'
    indexes :width,      type: 'integer', index: 'not_analyzed'
    indexes :height,     type: 'integer', index: 'not_analyzed'
    indexes :source,     type: 'string'
    indexes :views,      type: 'integer', index: 'not_analyzed'
    indexes :colors,     type: 'string',  analyzer: 'keyword'
  end

  # Validation
  validates :image, presence: true
  validates_size_of :image,      maximum: 20.megabytes,                       on: :create
  validates_property :mime_type, of: :image, in: ['image/jpeg', 'image/png'], on: :create
  validates_property :width,     of: :image, in: (600..10240),                on: :create
  validates_property :height,    of: :image, in: (600..10240),                on: :create

  # Scopes
  scope :processing, -> { where(processing: true ) }
  scope :processed,  -> { where(processing: false) }
  scope :visible, -> { processed }
  scope :latest, -> { order(created_at: :desc) }
  # scope :near_to_color, ->(color) {
  #   return if color.blank?
  #   color_ids = Kolor.near_to(color).map(&:id)
  #   # where(primary_color_id: color_ids) # @todo improve color search algorithm
  #   joins(:wallpaper_colors)
  #     .where(wallpaper_colors: { color_id: color_ids })
  #     .except(:order)
  #     .order('wallpaper_colors.percentage DESC')
  #     .references(:wallpaper_colors)
  #     # .select('wallpapers.*')
  #     # .where(wallpaper_colors: { color_id: color_ids })
  #     # .group('wallpapers.id')
  #     # .order('wallpaper_colors.percentage DESC')
  # }

  # Callbacks
  after_create :queue_create_thumbnails
  after_create :queue_extract_colors
  around_save :check_image_gravity_changed
  after_save :update_processing_status, if: :processing?
  after_save :update_index, unless: :processing?
  after_destroy :update_index

  class << self
    def search(params)
      tire.search load: true, page: params[:page], per_page: (params[:per_page] || default_per_page) do
        query do
          boolean do
            must { string params[:q], default_operator: 'AND', lenient: true } if params[:q].present?

            if params[:tags].present?
              params[:tags].each do |tag|
                must { term :tags, tag.downcase }
              end
            end

            if params[:exclude_tags].present?
              params[:exclude_tags].each do |tag|
                must_not { term :tags, tag.downcase }
              end
            end

            must { terms :purity, params[:purity] || ['sfw'] }

            must { term :width,  params[:width]  } if params[:width].present?
            must { term :height, params[:height] } if params[:height].present?

            if params[:colors].present?
              params[:colors].each do |color|
                must { term :colors, color.downcase }
              end
            end
          end
        end
        sort { by :created_at, 'desc' } if params[:query].blank? || params[:colors].blank?
        facet 'tags' do
          terms :tags, size: 20 # all_terms: true
        end
        facet 'purity' do
          terms :purity, all_terms: true
        end
      end
    end
  end

  def image_storage_path(i)
    name = File.basename(image_uid, (image.ext || '.jpg'))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join('/')
  end

  def queue_create_thumbnails
    WallpaperResizerWorker.perform_async(id)
  end

  def queue_extract_colors
    WallpaperColorExtractorWorker.perform_async(id)
  end

  def update_processing_status
    if has_image_sizes?
      self.processing = false
      save
    end
  end

  def has_image_sizes?
    image.present? && thumbnail_image.present?
  end

  def extract_colors
    return unless image.present?

    histogram = Colorscore::Histogram.new(image.path)

    # self.primary_color = Kolor.find_or_create_by_color(histogram.scores.first[1])

    # dominant_colors = Miro::DominantColors.new(image.path)
    # hexes = dominant_colors.to_hex
    # rgbs = dominant_colors.to_rgb
    # percentages = dominant_colors.by_percentage

    # # clear any old colors
    # self.primary_color = nil
    wallpaper_colors.clear

    # hexes.each_with_index do |hex, i|
    #   hex = hex[1..-1]
    #   color = Kolor.find_or_create_by(hex: hex, red: rgbs[i][0], green: rgbs[i][1], blue: rgbs[i][2])
    #   self.primary_color = color if i == 0
    #   self.wallpaper_colors.create color: color, percentage: percentages[i]
    # end

    palette = Colorscore::Palette.default
    scores = palette.scores(histogram.scores)

    scores.each do |score|
      color = Kolor.find_or_create_by_color(score[1])
      self.wallpaper_colors.create(color: color, percentage: score[0])
    end

    touch
  end

  def check_image_gravity_changed
    image_gravity_changed = image_gravity_changed?
    yield
    queue_create_thumbnails if image_gravity_changed
  end

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

  def to_indexed_json
    {
      user_id: user_id,
      user: user.try(:username),
      purity: purity,
      tags: tag_list,
      width: image_width,
      height: image_height,
      source: source,
      views: impressions_count,
      colors: wallpaper_colors.map { |color| [color.hex] * (color.percentage * 10).ceil }.flatten,
      created_at: created_at,
      updated_at: updated_at
    }.to_json
  end

  def to_s
    "Wallpaper \##{id}"
  end

  def to_resolution_text
    "#{image_width}x#{image_height}"
  end

  def lock_purity!
    update_attribute :purity_locked, true
  end

  def unlock_purity!
    update_attribute :purity_locked, false
  end
end