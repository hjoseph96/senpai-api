# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id , :phone, :first_name, :gender, :verified,
    :display_city, :display_state, :latlong, :age,
    :occupation, :created_at, :premium, :banned, :warning_count,
    :cover_photo_url, :orientation, :photos


  def age
    now = Time.now.utc.to_date
    dob = object.birthday.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def latlong
    { lat: object.lonlat.latitude, long: object.lonlat.longitude } if object.lonlat.present?
  end

  def cover_photo_url
    cdn_for object.photos.order(order: :desc).first.try(:image)
  end

  def photos
    object.photos.order(order: :desc).map { |p| cdn_for p.image }
  end

  def orientation
    case
      when is_straight? then 'straight'
      when is_bisexual? then 'bisexual'
      when is_gay? then 'gay'
    end
  end

  def is_straight?
    (object.male? && object.desires_women?) || (object.female? && object.desires_men?)
  end

  def is_bisexual?
    object.desires_both?
  end

  def is_gay?
    (object.female? && object.desires_women?) || (object.male? && object.desires_men?)
  end
end