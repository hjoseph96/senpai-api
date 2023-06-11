class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable

  has_many :user_animes, dependent: :destroy
  has_many :animes, through: :user_animes
  has_many :user_likes, dependent: :destroy
  has_many :likes, through: :user_likes

  enum :gender, [ :male, :female ]

  validates :phone, presence: true, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
