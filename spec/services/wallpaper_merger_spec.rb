require 'spec_helper'

describe WallpaperMerger do
  context 'when have two wallpapers to merge' do
    let(:from_wallpaper) { create(:wallpaper, tag_list: 'three, two, one', source: 'New source') }
    let(:to_wallpaper)   { create(:wallpaper, tag_list: 'three, four, five, six', source: nil) }
    let(:wallpaper_merger) { WallpaperMerger.new(from_wallpaper, to_wallpaper) }

    context 'after execution' do
      let(:new_wallpaper) { wallpaper_merger.execute }

      it { expect(new_wallpaper).to be_a_kind_of(Wallpaper) }
      it { expect(new_wallpaper).to be_eql(to_wallpaper) }
      it { expect(new_wallpaper.tag_list.sort).to eql(['one', 'two', 'three', 'four', 'five', 'six'].sort) }
      it { expect(new_wallpaper.source).to eql('New source') }
    end

    it 'destroys old wallpaper' do
      expect(from_wallpaper).to receive(:destroy)
      wallpaper_merger.execute
    end
  end
end