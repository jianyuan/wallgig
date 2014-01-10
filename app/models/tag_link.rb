class TagLink < ActiveRecord::Base
  belongs_to :parent, class_name: 'ActsAsTaggableOn::Tag'
  belongs_to :child, class_name: 'ActsAsTaggableOn::Tag'
end
