# == Schema Information
#
# Table name: users
#
#  id                            :integer          not null, primary key
#  username                      :string(20)       not null
#  created_at                    :datetime
#  updated_at                    :datetime
#  name                          :string(255)
#  bio_raw                       :text
#  seen_notification_id          :integer          default(0), not null
#  last_posted_at                :datetime
#  email                         :string(256)      not null
#  password_hash                 :string(64)
#  salt                          :string(32)
#  active                        :boolean
#  username_lower                :string(20)       not null
#  auth_token                    :string(32)
#  last_seen_at                  :datetime
#  website                       :string(255)
#  admin                         :boolean          default(FALSE), not null
#  last_emailed_at               :datetime
#  email_digests                 :boolean          not null
#  trust_level                   :integer          not null
#  bio_cooked                    :text
#  email_private_messages        :boolean          default(TRUE)
#  email_direct                  :boolean          default(TRUE), not null
#  approved                      :boolean          default(FALSE), not null
#  approved_by_id                :integer
#  approved_at                   :datetime
#  digest_after_days             :integer
#  previous_visit_at             :datetime
#  suspended_at                  :datetime
#  suspended_till                :datetime
#  date_of_birth                 :date
#  auto_track_topics_after_msecs :integer
#  views                         :integer          default(0), not null
#  flag_level                    :integer          default(0), not null
#  ip_address                    :inet
#  new_topic_duration_minutes    :integer
#  external_links_in_new_tab     :boolean          default(FALSE), not null
#  enable_quoting                :boolean          default(TRUE), not null
#  moderator                     :boolean          default(FALSE)
#  blocked                       :boolean          default(FALSE)
#  dynamic_favicon               :boolean          default(FALSE), not null
#  title                         :string(255)
#  use_uploaded_avatar           :boolean          default(FALSE)
#  uploaded_avatar_template      :string(255)
#  uploaded_avatar_id            :integer
#  email_always                  :boolean          default(FALSE), not null
#

module Discourse
  class User < ActiveRecord::Base
    establish_connection "discourse_#{Rails.env}"

    has_one :user_stat

    after_create :create_user_stat

    def self.new_from_user(user)
      User.new do |u|
        u.refresh_from_user(user)
        u.active = true
        u.email_digests = true
        u.trust_level = 0
        u.approved = true
        u.digest_after_days = 7
      end
    end

    def refresh_from_user(user)
      self.username = user.username
      self.name = user.username
      self.email = user.email
      self.username_lower = user.username.downcase
    end

    def regenerate_auth_token!
      self.auth_token = SecureRandom.hex(16)
      self.save!
    end

    private
      def create_user_stat
        stat = UserStat.new
        stat.user_id = id
        stat.save!
      end

  end
end
