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
#  wallpapers_count       :integer          default(0)
#  moderator              :boolean          default(FALSE)
#  admin                  :boolean          default(FALSE)
#  developer              :boolean          default(FALSE)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :login

  has_many :collections, dependent: :destroy
  has_many :wallpapers, dependent: :nullify
  has_many :favourites, dependent: :destroy
  has_many :favourite_wallpapers, -> { reorder('favourites.created_at DESC') }, through: :favourites, source: :wallpaper

  has_one :profile,  class_name: 'UserProfile', dependent: :destroy
  has_one :settings, class_name: 'UserSetting', dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  acts_as_commentable

  is_impressionable

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*\z/, message: 'Only letters, numbers, and underscores allowed.' },
            length: { minimum: 3, maximum: 20 }

  before_save :ensure_authentication_token

  before_create do
    build_profile
    build_settings
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  def to_param
    username
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    reset_authentication_token
    save validate: false
  end

  def ensure_authentication_token
    reset_authentication_token if authentication_token.blank?
  end

  def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end

  def settings
    super || build_settings
  end

  def profile
    super || build_profile
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.where(authentication_token: token).exists?
    end
  end
end
