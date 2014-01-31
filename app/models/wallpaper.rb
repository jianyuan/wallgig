# == Schema Information
#
# Table name: wallpapers
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  purity                :string(255)
#  processing            :boolean          default(TRUE)
#  image_uid             :string(255)
#  image_name            :string(255)
#  image_width           :integer
#  image_height          :integer
#  created_at            :datetime
#  updated_at            :datetime
#  thumbnail_image_uid   :string(255)
#  primary_color_id      :integer
#  impressions_count     :integer          default(0)
#  cached_tag_list       :text
#  image_gravity         :string(255)      default("c")
#  favourites_count      :integer          default(0)
#  purity_locked         :boolean          default(FALSE)
#  source                :string(255)
#  phash                 :integer
#  scrape_source         :string(255)
#  scrape_id             :string(255)
#  image_hash            :string(255)
#  category_id           :integer
#  cached_votes_total    :integer          default(0)
#  cached_votes_score    :integer          default(0)
#  cached_votes_up       :integer          default(0)
#  cached_votes_down     :integer          default(0)
#  cached_weighted_score :integer          default(0)
#

require 'redcarpet_renderers'

class Wallpaper < ActiveRecord::Base
  belongs_to :user, counter_cache: true

  has_many :wallpaper_colors, -> { order('wallpaper_colors.percentage DESC') }, dependent: :destroy
  has_many :colors, through: :wallpaper_colors, class_name: 'Kolor'
  belongs_to :primary_color, class_name: 'Kolor'

  has_many :favourites, dependent: :destroy
  has_many :favourited_users, through: :favourites, source: :wallpaper

  belongs_to :category

  include Reportable

  acts_as_votable

  # Purity
  extend Enumerize
  enumerize :purity, in: [:sfw, :sketchy, :nsfw], default: :sfw, scope: true, predicates: true
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
  tire.settings :analysis => {
                  :analyzer => {
                    :'string_lowercase' => {
                      :tokenizer => 'keyword',
                      :filter => 'lowercase'
                    }
                  }
                } do
    tire.mapping do
      indexes :user_id, type: 'integer', index: 'not_analyzed'
      indexes :user,    type: 'string',  index: 'not_analyzed'
      indexes :purity,  type: 'string',  index: 'not_analyzed'
      indexes :tags,       type: 'string', analyzer: 'string_lowercase'
      indexes :categories, type: 'string', analyzer: 'string_lowercase'
      indexes :width,   type: 'integer', index: 'not_analyzed'
      indexes :height,  type: 'integer', index: 'not_analyzed'
      indexes :source,  type: 'string'
      indexes :colors do
        indexes :hex,        type: 'string',  analyzer: 'keyword'
        indexes :percentage, type: 'integer', index: 'not_analyzed'
      end
      indexes :views,                type: 'integer', index: 'not_analyzed'
      indexes :views_today,          type: 'integer', index: 'not_analyzed'
      indexes :views_this_week,      type: 'integer', index: 'not_analyzed'
      indexes :favourites,           type: 'integer', index: 'not_analyzed'
      indexes :favourites_today,     type: 'integer', index: 'not_analyzed'
      indexes :favourites_this_week, type: 'integer', index: 'not_analyzed'
    end
  end

  # Validation
  validates_presence_of :purity
  validates_presence_of :image
  validates_size_of :image,      maximum: 20.megabytes,                       on: :create
  validates_property :mime_type, of: :image, in: ['image/jpeg', 'image/png'], on: :create
  validates_property :width,     of: :image, in: (600..10240),                on: :create
  validates_property :height,    of: :image, in: (600..10240),                on: :create

  unless Rails.env.development?
    validate :check_duplicate_image_hash, on: :create
  end

  # Scopes
  scope :processing,    -> { where(processing: true ) }
  scope :processed,     -> { where(processing: false) }
  scope :visible,       -> { processed }
  scope :latest,        -> { order(created_at: :desc) }
  scope :with_purities, -> (*purities) { where(purity: purities) }
  scope :similar_to,    -> (w) { where.not(id: w.id).where(["( SELECT SUM(((phash::bigint # ?) >> bit) & 1 ) FROM generate_series(0, 63) bit) <= 15", w.phash]) }

  # Callbacks
  before_validation :set_image_hash, on: :create

  after_create :queue_create_thumbnails
  after_create :queue_process_image
  around_save :check_image_gravity_changed

  before_save do
    if tag_list.empty?
      self.tag_list << 'tagme'
    else
      tag_list.remove('tagme')
    end
  end

  after_save :update_processing_status, if: :processing?

  unless Rails.env.test?
    after_save :update_index, unless: :processing?
    after_destroy :update_index
  end

  def self.ensure_consistency!
    connection.execute('
      UPDATE wallpapers SET favourites_count = (
        SELECT COUNT(*) FROM favourites WHERE favourites.wallpaper_id = wallpapers.id
      )
    ')
  end

  def image_storage_path(i)
    name = File.basename(image_uid, (image.ext || '.jpg'))
    [File.dirname(image_uid), "#{name}_#{i.width}x#{i.height}.#{i.format}"].join('/')
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
    return unless image.present? && image.format == 'jpeg'

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
      user_id:              user_id,
      user:                 user.try(:username),
      purity:               purity,
      tags:                 tag_list,
      categories:           category_list,
      width:                image_width,
      height:               image_height,
      source:               source,
      views:                impressions_count,
      views_today:          impressionist_count(start_date: Time.now.beginning_of_day),
      views_this_week:      impressionist_count(start_date: Time.now.beginning_of_week),
      favourites:           cached_votes_total,
      favourites_today:     favourites.where('created_at >= ?', Time.now.beginning_of_day).size, # FIXME
      favourites_this_week: favourites.where('created_at >= ?', Time.now.beginning_of_week).size, # FIXME
      colors:               wallpaper_colors.includes(:color).map { |color| { hex: color.hex, percentage: (color.percentage * 10).ceil } },
      created_at:           created_at,
      updated_at:           updated_at
    }.to_json
  end

  def to_s
    "Wallpaper \##{id}"
  end

  def lock_purity!
    update_attribute :purity_locked, true
  end

  def unlock_purity!
    update_attribute :purity_locked, false
  end

  def update_phash
    # TODO disable this for now
    # return unless image.present?

    # fingerprint = Phashion::Image.new(image.path).fingerprint
    # self.phash = (fingerprint & ~(1 << 63)) - (fingerprint & (1 << 63)) # convert 64 bit unsigned to signed
    # self.save
  end

  def similar_wallpapers
    Wallpaper.similar_to(self)
  end

  def queue_create_thumbnails
    WallpaperResizerWorker.perform_async(id)
  end

  def queue_process_image
    WallpaperAttributeUpdateWorker.perform_async(id, 'process_image')
  end

  def process_image
    extract_colors
    update_phash
  end

  def resolutions
    @resolutions ||= WallpaperResolutions.new(self)
  end

  attr_reader :resized_image
  attr_reader :resized_image_resolution

  def resize_image_to(resolution)
    return false unless resolutions.include?(resolution)
    @resized_image = image.thumb("#{resolution.to_geometry_s}\##{image_gravity}")
    @resized_image_resolution = resolution
    true
  end

  def set_image_hash
    self.image_hash = Digest::MD5.hexdigest(image.file.read) if image.present?
  end

  def category_list
    return nil unless category.present?
    category.ancestors.pluck(:name) << category.name
  end

  def cooked_source
    @cooked_source ||= begin
      renderer = Redcarpet::Render::HTMLWithoutBlockElements.new({
        filter_html: true,
        hard_wrap: true
      })
      markdown = Redcarpet::Markdown.new(renderer, {
        autolink: true,
        no_intra_emphasis: true
      })
      markdown.render(source).html_safe
    end if source.present?
  end

  def image_name
    nil # temporarily disabled image name
  end

  private

  def check_duplicate_image_hash
    if image_hash.present? && (duplicate = self.class.where.not(id: self.id).where(image_hash: image_hash).first)
      errors.add :image, "has already been uploaded (#{duplicate})"
    end
  end
end
