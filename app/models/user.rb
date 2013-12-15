# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  discourse_user_id      :integer
#

class User < ActiveRecord::Base
  has_many :collections, dependent: :destroy
  has_many :wallpapers
  has_many :favourites
  has_many :wallpaper_favourites, through: :favourites, source: :user

  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*\z/, message: 'Only letters, numbers, and underscores allowed.' },
            length: { maximum: 50 }

  # after_create :create_discourse_user

  def developer?
    has_role? :developer
  end

  def admin?
    has_role? :admin
  end

  def moderator?
    has_role? :moderator
  end

  def to_param
    username
  end

  # def discourse_user
  #   Discourse::User.find(discourse_user_id) if discourse_user_id.present?
  # end

  # def refresh_discourse_user
  #   du = discourse_user
  #   return if du.blank?
  #   du.refresh_from_user(self)
  #   du.save
  # end

  # def create_discourse_user
  #   self.discourse_user_id = Discourse::User.find_or_create_by_user(self).id
  #   save!
  # end

end
