# == Schema Information
#
# Table name: user_stats
#
#  user_id           :integer          not null, primary key
#  has_custom_avatar :boolean          default(FALSE), not null
#  topics_entered    :integer          default(0), not null
#  time_read         :integer          default(0), not null
#  days_visited      :integer          default(0), not null
#  posts_read_count  :integer          default(0), not null
#  likes_given       :integer          default(0), not null
#  likes_received    :integer          default(0), not null
#  topic_reply_count :integer          default(0), not null
#

module Discourse
  class UserStat < ActiveRecord::Base
    establish_connection "discourse_#{Rails.env}"

    belongs_to :user
  end
end
