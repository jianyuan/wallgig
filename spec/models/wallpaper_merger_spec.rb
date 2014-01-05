require 'spec_helper'

describe WallpaperMerger do
  context 'when have two wallpapers to merge' do
    let!(:from_wallpaper) { create(:wallpaper, tag_list: 'three, two, one', source: 'New source') }
    let!(:to_wallpaper)   { create(:wallpaper, tag_list: 'three, four, five, six', source: nil) }
    let!(:wallpaper_merger) { WallpaperMerger.from(from_wallpaper).to(to_wallpaper) }

    context 'after execution' do
      let!(:merge_result) { wallpaper_merger.execute }

      it { puts to_wallpaper; expect(merge_result).to be_true }
      it { expect(to_wallpaper.tag_list.sort).to eql(['one', 'two', 'three', 'four', 'five', 'six'].sort) }
      it { expect(to_wallpaper.source).to eql('New source') }
    end

    it 'destroys old wallpaper' do
      expect(from_wallpaper).to receive(:destroy)
      wallpaper_merger.execute
    end
  end
end