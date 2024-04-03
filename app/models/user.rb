class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable

  acts_as_paranoid

  has_many :user_animes, dependent: :destroy
  has_many :animes, through: :user_animes
  has_many :likes, dependent: :destroy
  has_many :user_conversations, dependent: :destroy
  has_many :conversations, through: :user_conversations, dependent: :destroy

  has_one :gallery, dependent: :destroy
  has_many :photos, through: :gallery

  has_many :matches, dependent: :destroy
  has_many :favorite_music, dependent: :destroy
  has_many :verify_requests, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :blocks, foreign_key: :blocker_id, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :push_notifications, dependent: :delete_all
  has_many :reviews, as: :reviewable
  has_many :device_infos, dependent: :destroy

  has_many :events, foreign_key: :host_id, class_name: 'Event', dependent: :destroy
  has_many :hosted_parties, foreign_key: :host_id, class_name: 'Party', dependent: :destroy
  has_many :user_parties, dependent: :destroy
  has_many :attended_parties, through: :user_parties, source: 'party', dependent: :destroy
  has_many :join_requests, dependent: :destroy
  has_many :user_conventions, dependent: :destroy
  has_many :attended_conventions, through: :user_conventions, source: 'convention', dependent: :destroy

  has_one :influencer, dependent: :destroy

  has_many :referrals, foreign_key: :referer_id, class_name: 'Referral'
  has_one :referred_by, foreign_key: :referred_id, class_name: 'Referral'

  has_one_attached :referral_qr_code

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
  scope :profile_unfilled, -> { includes(:user_animes).where(user_animes: { user_id: nil }) }


  validates :phone, presence: true, uniqueness: true
  validate :validate_age

  after_commit :clear_feed
  after_create_commit :generate_qr_code


  def generate_qr_code
    qrcode = RQRCode::QRCode.new("http://github.com/")

    # NOTE: showing with default options specified explicitly
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )

    self.referral_qr_code.attach(
      io: StringIO.new(png.to_s),
      filename: "referral_qrcode.png",
      content_type: "image/png"
    )

    self.save!
  end

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

    self.online!
  end

  def disappear
    offline!
  end

  def has_liked?(user)
    self.likes.where(likee_id: user.id).present?
  end

  def self.has_liked?(likes, user)
    likes.select { |like| like.likee_id == user.id }.present?
  end

  def matched_with?(user)
    self.matches.where(matchee_id: user.id).count > 0
  end

  def self.matched_with?(matches, user)
    matches.select { |match| match.matchee_id == user.id }.present?
  end

  def blocked?(user)
    self.blocks.where(blockee_id: user.id).present?
  end

  def self.blocked?(blocks, user)
    blocks.select { |block| block.blockee_id == user.id }.present?
  end

  def host_reviews
    self.reviews.where(review_type: :host)
  end

  def host_score
    return nil if host_reviews.empty?

    scores = self.host_reviews.pluck(:score)
    scores.inject{ |sum, score| sum + score }.to_f / scores.size
  end

  def party_member_reviews
    self.reviews.where(review_type: :party_member)
  end

  def party_member_score
    return nil if party_member_reviews.empty?

    scores = self.party_member_reviews.pluck(:score)
    scores.inject{ |sum, score| sum + score }.to_f / scores.size
  end
end
