# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Tag < ActsAsTaggableOn::Tag
  scope :alphabetically, -> { order 'LOWER(name) ASC' }
end