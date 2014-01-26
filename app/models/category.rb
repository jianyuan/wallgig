# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  slug            :string(255)
#  wikipedia_title :string(255)
#  raw_content     :text
#  cooked_content  :text
#  ancestry        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'wikipedia_client'

class Category < ActiveRecord::Base
  has_ancestry

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true

  before_save :fetch_wikipedia_content, if: proc { |c| c.raw_content.blank? && c.wikipedia_title.present? }

  def fetch_wikipedia_content
    self.cooked_content = WikipediaClient.new(wikipedia_title).extract if wikipedia_title.present?
  end

  # Taken from https://github.com/stefankroes/ancestry/wiki/Creating-a-selectbox-for-a-form-using-ancestry
  def self.arrange_as_array(options = {}, hash = nil)                                                                                                                                                            
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.nil?
    end
    arr
  end

  def name_for_selects
    "#{'-' * depth} #{name}"
  end

  def possible_parents
    parents = Category.arrange_as_array(order: :name)
    return new_record? ? parents : parents - subtree
  end
end
