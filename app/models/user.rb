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
#

class User < ActiveRecord::Base
  has_many :collections, dependent: :destroy
  has_many :wallpapers
  has_many :favourites
  has_many :favourite_wallpapers, through: :favourites, source: :wallpaper

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  acts_as_commentable

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*\z/, message: 'Only letters, numbers, and underscores allowed.' },
            length: { maximum: 50 }

  def to_param
    username
  end
end
