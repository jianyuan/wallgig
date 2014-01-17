# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  reportable_id   :integer
#  reportable_type :string(255)
#  user_id         :integer
#  description     :text
#  closed_by_id    :integer
#  closed_at       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Report < ActiveRecord::Base
  belongs_to :reportable, polymorphic: true
  belongs_to :user
  belongs_to :closed_by, class_name: 'User'
end
