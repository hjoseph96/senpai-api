class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable

  acts_as_paranoid

  has_many :user_animes, dependent: :destroy
  has_many :animes, through: :user_animes
  has_many :user_likes, dependent: :destroy
  has_many :likes, through: :user_likes
  has_many :user_conversations, dependent: :destroy
  has_many :conversations, through: :user_conversations

  has_one :gallery, dependent: :destroy
  has_many :photos, through: :gallery

  has_many :matches
  has_many :favorite_music
  has_many :verify_requests
  has_many :reports
  has_many :blocks, foreign_key: :blocker_id

  enum :online_status, [ :online, :offline ]
  enum :role, [ :user, :mod, :admin ]
  enum :gender, [ :male, :female ]
  enum :desired_gender, [ :desires_men, :desires_women ]

  scope :within, -> (latitude, longitude, distance_in_mile = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  }


  validates :phone, presence: true, uniqueness: true
  validate :validate_age

  def validate_age
    if birthday.present? && birthday > 18.years.ago
      errors.add(:birthday, 'You should be over 18 years old.')
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def current_sign_in_ip
    ip = read_attribute(:current_sign_in_ip)

    ip == '127.0.0.1' ? '173.52.91.160' : ip
  end

  def update_devise_fields!(ip)
    self.update!(
      current_sign_in_at: DateTime.now,
      current_sign_in_ip: ip,
      sign_in_count: self.sign_in_count + 1,
      last_sign_in_at: self.current_sign_in_at,
      last_sign_in_ip: self.current_sign_in_ip
    )
  end

  def appear(on: nil)
    online!
    on.nil? ? self.touch(:updated_at) : self.update(updated_at: on)
  end

  def disappear
    offline!
  end

  def has_liked?(user)
    self.likes.where(likee_id: user.id).present?
  end

  def matched_with?(user)
    self.matches.where(matchee_id: user.id).count > 0
  end
end
