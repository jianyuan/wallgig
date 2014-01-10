ActsAsTaggableOn::Tag.class_eval do
  has_many :parent_links, class_name: '::TagLink', foreign_key: 'child_id', dependent: :destroy
  has_many :parents, through: :parent_links

  has_many :child_links, class_name: '::TagLink', foreign_key: 'parent_id', dependent: :destroy
  has_many :children, through: :child_links

  extend ::FriendlyId
  friendly_id :name, use: :slugged

  scope :alphabetically, -> { order 'LOWER(name) ASC' }
  scope :name_like, -> (query) { where('LOWER(name) LIKE ?', "%#{query}%") if query.present? }
end