# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#  slug :string(255)
#

class ActsAsTaggableOn::Tag
  scope :alphabetically, -> { order 'LOWER(name) ASC' }
  scope :name_like, -> (query) { where('LOWER(name) LIKE ?', "%#{query}%") if query.present? }

  # extend FriendlyId
  # friendly_id :name, use: :slugged

  def to_param
    name
  end
end
