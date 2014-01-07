# == Schema Information
#
# Table name: colors
#
#  id    :integer          not null, primary key
#  red   :integer
#  green :integer
#  blue  :integer
#  hex   :string(255)
#

require 'spec_helper'

describe Kolor do
  describe 'associations' do
    it { should have_many(:wallpaper_colors).with_foreign_key('color_id').dependent(:destroy) }
    it { should have_many(:wallpapers).through(:wallpaper_colors).with_foreign_key('color_id') }
  end

  describe 'validations' do
    it { should validate_presence_of :red }
    it { should validate_presence_of :green }
    it { should validate_presence_of :blue }
    it { should validate_presence_of :hex }
  end

  describe '::normalize_html_hex' do
    it 'returns correct normalized html hex' do
      expect(Kolor.normalize_html_hex('#000000')).to eq('000000')
      expect(Kolor.normalize_html_hex('000000')).to eq('000000')
      expect(Kolor.normalize_html_hex('AAAAAA')).to eq('aaaaaa')
      expect(Kolor.normalize_html_hex('ZZZZZZ')).to be_nil
      expect(Kolor.normalize_html_hex(123456)).to be_nil
      expect(Kolor.normalize_html_hex(nil)).to be_nil
    end
  end
end
