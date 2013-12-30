ActsAsTaggableOn::Tag.class_eval do
  scope :alphabetically, -> { order 'LOWER(name) ASC' }

  extend FriendlyId
  friendly_id :name, use: :slugged
end