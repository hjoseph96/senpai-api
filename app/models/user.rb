class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable

  acts_as_paranoid

  has_many :user_animes, dependent: :delete_all
  has_many :animes, through: :user_animes, dependent: :delete_all
  has_many :user_likes, dependent: :delete_all
  has_many :likes, through: :user_likes, dependent: :delete_all
  has_many :user_conversations, dependent: :delete_all
  has_many :conversations, through: :user_conversations, dependent: :delete_all

  has_one :gallery, dependent: :destroy
  has_many :photos, through: :gallery, dependent: :delete_all

  has_many :matches, dependent: :delete_all
  has_many :favorite_music, dependent: :delete_all
  has_many :verify_requests, dependent: :delete_all
  has_many :reports, dependent: :delete_all
  has_many :blocks, foreign_key: :blocker_id, dependent: :delete_all
  has_many :recommendations, dependent: :delete_all
  has_one :influencer, dependent: :delete

  enum :online_status, [ :online, :offline ]
  enum :role, [ :user, :mod, :admin ]
  enum :gender, { male: 0, female: 1 }
  enum :desired_gender, {
    desires_men: 0,
    desires_women: 1,
    desires_both: 2
  }

  scope :within, -> (latitude, longitude, distance_in_mile = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  }

  scope :profile_filled, -> { joins(:user_animes)
                                .group('users.id')
                                .having("count('animes.id') > 0") }


  validates :phone, presence: true, uniqueness: true
  validate :validate_age

  after_commit :clear_feed

  def validate_age
    if birthday.present? && birthday > 18.years.ago
      errors.add(:birthday, 'You should be over 18 years old.')
    end
  end

  def clear_feed
    if %w(gender desired_gender).any? {|c| previous_changes.keys.include?(c) }
      cache_key = "#{self.id}-FEED"
      feed = Rails.cache.read(cache_key)
      Rails.cache.delete(cache_key) if feed.present?
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

  def on_the_team?
    self.admin? || self.mod?
  end

  def profile_filled?
    self.animes.count > 0
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

  def blocked?(user_id)
    self.blocks.where(blockee_id: user_id).present?
  end

end
