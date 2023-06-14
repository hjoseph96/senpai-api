class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable

  has_many :user_animes, dependent: :destroy
  has_many :animes, through: :user_animes
  has_many :user_likes, dependent: :destroy
  has_many :likes, through: :user_likes
  has_and_belongs_to_many :conversations, dependent: :destroy

  has_one :gallery
  has_many :photos, through: :gallery

  has_many :favorite_music

  enum :gender, [ :male, :female ]
  enum :desired_gender, [ :desires_men, :desires_women ]

  validates :phone, presence: true, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
