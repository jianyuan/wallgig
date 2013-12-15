# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  public     :boolean
#  ancestry   :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Collection < ActiveRecord::Base
  belongs_to :user

  has_ancestry
  acts_as_list scope: [:ancestry]
end
