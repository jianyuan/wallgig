class WallpaperResolutions
  include Enumerable

  array_methods = Array.instance_methods - Object.instance_methods
  delegate :==, :as_json, *array_methods, to: :collection

  def initialize(wallpaper)
    @wallpaper = wallpaper
  end

  def collection
    @collection ||= ScreenResolution.where('width <= :width AND height <= :height', width: @wallpaper.image_width, height: @wallpaper.image_height)
  end

  def array_for_options
    unflattened_options = {}

    each do |r|
      unflattened_options[r.category_text] ||= []
      unflattened_options[r.category_text] << [r.to_s, r.to_geometry_s, { data: { width: r.width, height: r.height } }]
    end

    options = []
    unflattened_options.each_pair do |cat, opts|
      options << [cat, opts]
    end
    options
  end
end