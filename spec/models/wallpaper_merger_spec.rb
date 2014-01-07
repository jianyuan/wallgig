require 'spec_helper'

describe WallpaperMerger do
  context 'merge two wallpapers' do
    let(:old_wallpaper) { create(:wallpaper, tag_list: 'a, b, c', source: 'New source') }
    let(:new_wallpaper)   { create(:wallpaper, tag_list: 'c, d, e, f', source: nil) }
    let!(:wallpaper_merger) { WallpaperMerger.from(old_wallpaper).to(new_wallpaper) }

    context 'basic merge' do
      let!(:old_comment) { create(:comment, commentable: old_wallpaper) }
      let!(:old_favourite) { create(:favourite, wallpaper: old_wallpaper) }
      let!(:merge_result) { wallpaper_merger.execute }

      it 'succeeds' do
        expect(merge_result).to be_true
      end

      it 'destroys old wallpaper' do
        expect { old_wallpaper.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'merges and removes duplicate tags' do
        expect(new_wallpaper.tag_list.sort).to eq(%w(a b c d e f))
      end

      it 'updates source attribute from old wallpaper' do
        expect(new_wallpaper.source).to eq('New source')
      end

      it 'moves favourites' do
        old_favourite.reload
        expect(old_favourite.wallpaper).to eq(new_wallpaper)
      end

      it 'moves comments' do
        old_comment.reload
        expect(old_comment.commentable).to eq(new_wallpaper)
      end
    end

    context 'with duplicate favourites' do
      let(:user) { create(:user) }
      let!(:favourite_1) { create(:favourite, user: user, wallpaper: old_wallpaper) }
      let!(:favourite_2) { create(:favourite, user: user, wallpaper: new_wallpaper) }

      let!(:merge_result) { wallpaper_merger.execute }

      it 'succeeds' do
        expect(merge_result).to be_true
      end

      it 'moves favourites' do
        ids = [favourite_1.id, favourite_2.id]
        expect(Favourite.where(id: ids).count).to eq(1)
      end
    end
  end
end