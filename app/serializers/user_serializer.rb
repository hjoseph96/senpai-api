# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id , :phone, :first_name, :gender, :verified,
    :display_city, :display_state, :latlong, :age,
    :occupation, :created_at, :premium, :cover_photo_url

  def age
    now = Time.now.utc.to_date
    dob = object.birthday.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def latlong
    { lat: object.lonlat.latitude, long: object.lonlat.longitude } if object.lonlat.present?
  end

  def cover_photo_url
    cdn_for object.photos.order(order: :desc).first.image
  end
end