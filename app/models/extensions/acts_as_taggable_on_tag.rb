ActsAsTaggableOn::Tag.class_eval do
  scope :alphabetically, -> { order 'LOWER(name) ASC' }
  scope :name_like, -> (query) { where('LOWER(name) LIKE ?', "%#{query}%") if query.present? }

  # extend FriendlyId
  # friendly_id :name, use: :slugged

  def to_param
    name
  end
end