class Event < ApplicationRecord
  has_one :party

  belongs_to :host, foreign_key: :host_id, class_name: 'User'
  belongs_to :convention, optional: true
  has_many :join_requests

  has_one_attached :cover_image

  validates :title, presence: true
  validates :start_date, presence: true
  validates :lonlat, presence: true
  validates :cosplay_required, presence: true
  validates :description, presence: true

  enum :cosplay_required, [:no, :optional, :required]

  include PgSearch::Model
  pg_search_scope :search_by_title, against: [:title],  using: { tsearch: { dictionary: 'english' } }


  after_create_commit :create_party
  after_create_commit :set_date_range

  scope :within, -> (latitude, longitude, distance_in_mile = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  }

  scope :accepting_members, -> () do
    Event.joins(:party).where(parties: { status: :open })
  end

  scope :full_party, -> () do
    Event.joins(:party).where(parties: { status: :full })
  end

  def create_party
    Party.create!(event_id: self.id, host_id: self.host_id)
  end

  def set_date_range
    return unless self.convention_id.present?

    self.update(start_date: self.convention.start_date, end_date: self.convention.end_date)
  end

  def is_running?
    event_end_date = self.end_date || self.start_date + 1

    self.start_date..event_end_date === DateTime.now
  end
end
