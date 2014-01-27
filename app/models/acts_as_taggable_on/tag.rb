# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class ActsAsTaggableOn::Tag
  scope :alphabetically, -> { order 'LOWER(name) ASC' }
  scope :name_like, -> (query) { where('LOWER(name) LIKE LOWER(?)', "#{query}%") if query.present? }

  def to_param
    name
  end
end
