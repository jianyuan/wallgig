class WallpaperCollectionStatus
  def initialize(collections, wallpaper)
    @collections = collections
    @wallpaper = wallpaper
  end

  def collection_ids
    @collections.map(&:id)
  end

  def collections
    @collection_ids_having_wallpaper = CollectionsWallpaper.where(wallpaper_id: @wallpaper.id, collection_id: collection_ids).pluck(:collection_id)

    @collections.each do |collection|
      collection.collect_status = @collection_ids_having_wallpaper.include?(collection.id)
    end
  end
end
