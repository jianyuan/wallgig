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
#  impressions_count   :integer          default(0)
#  cached_tag_list     :text
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

  # Tags
  acts_as_taggable

  # Pagination
  paginates_per 20

  # Views
  is_impressionable counter_cache: true

  # Paper trail
  has_paper_trail only: [:purity, :cached_tag_list]

  # Search
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # tire do
  #   mapping do
  #     indexes :id,                  type: 'string', index: 'not_analyzed'
  #     indexes :user_id,             type: 'integer', index: 'not_analyzed'
  #     indexes :width,               type: 'integer'
  #     indexes :height,              type: 'integer'
  #     indexes :purity,              type: 'string'
  #     indexes :tags,                type: 'string', analyzer: 'keyword'
  #     indexes :colors do
  #       indexes :red,               type: 'integer'
  #       indexes :green,             type: 'integer'
  #       indexes :blue,              type: 'integer'
  #       indexes :count,             type: 'float'
  #     end
  #     indexes :primary_color do
  #       indexes :red,               type: 'integer'
  #       indexes :green,             type: 'integer'
  #       indexes :blue,              type: 'integer'
  #     end
  #     indexes :thumbnail_image_uid, type: 'string', index: 'not_analyzed'
  #     indexes :created_at,          type: 'date_time'
  #     indexes :views,               type: 'integer'
  #   end
  # end

  # def to_indexed_json
  #   {
  #     id: id,
  #     user_id: user_id,
  #     width: image_width,
  #     height: image_height,
  #     purity: purity,
  #     tags: tag_list,
  #     colors: wallpaper_colors.map do |color|
  #       {
  #         red: color.red,
  #         green: color.green,
  #         blue: color.blue,
  #         percentage: color.percentage
  #       }
  #     end,
  #     primary_color: {
  #       red: primary_color.try(:red),
  #       green: primary_color.try(:green),
  #       blue: primary_color.try(:blue)
  #     },
  #     thumbnail_image_uid: thumbnail_image_uid,
  #     created_at: created_at,
  #     views: impressions_count
  #   }.to_json
  # end

  # def remove_index
  #   self.index.remove self
  # end

  # Validation
  validates :image, presence: true
  validates_property :mime_type, of: :image, in: ['image/jpeg', 'image/png'], on: :create
  validates_property :width,     of: :image, in: (600..10240),                on: :create
  validates_property :width,     of: :image, in: (600..10240),                on: :create

  # Scopes
  scope :processing, -> { where(processing: true ) }
  scope :processed,  -> { where(processing: false) }
  scope :visible, -> { processed }
  scope :near_to_color, ->(color) {
    return if color.blank?
    color_ids = Kolor.near_to(color).map(&:id)
    # where(primary_color_id: color_ids) # @todo improve color search algorithm
    joins(:wallpaper_colors)
      .where(wallpaper_colors: { color_id: color_ids })
      .except(:order)
      .order('wallpaper_colors.percentage DESC')
      .references(:wallpaper_colors)
      # .select('wallpapers.*')
      # .where(wallpaper_colors: { color_id: color_ids })
      # .group('wallpapers.id')
      # .order('wallpaper_colors.percentage DESC')
  }

  # Callbacks
  after_create :queue_create_thumbnails
  after_create :queue_extract_dominant_colors
  after_save :update_processing_status, if: :processing?

  def image_storage_path(i)
    name = File.basename(image_uid, (image.ext || '.jpg'))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join('/')
  end

  def queue_create_thumbnails
    WallpaperResizerWorker.perform_async(id)
  end

  def queue_extract_dominant_colors
    WallpaperExtractDominantColorsWorker.perform_async(id)
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


  def self.search(params)
    tire.search load: true, page: params[:page], per_page: 20 do
      query do
        boolean do
          must { string params[:query], default_operator: 'AND', lenient: true } if params[:query].present?

          if params[:tags].present?
            params[:tags].each do |tag|
              must { term :tags, tag }
            end
          end

          if params[:purity].present?
            params[:purity].each do |purity|
              must { term :purity, purity }
            end
          else
            must { term :purity, :sfw }
          end
        end
      end
      sort { by :created_at, 'desc' } if params[:query].blank?
      facet 'tags' do
        terms :tags, size: 20
      end
      facet 'purity' do
        terms :purity, all_terms: true
      end
    end
  end

  def to_indexed_json
    {
      id: id,
      user_id: user_id,
      purity: purity,
      tags: tag_list,
      width: image_width,
      height: image_height,
      created_at: created_at,
      updated_at: updated_at
    }.to_json
  end

end
