class VerifyRequestSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id , :user_id, :status, :created_at,
             :submitted_photo, :uploaded_photos

  def submitted_photo
    cdn_for(object.submitted_photo)
  end

  def uploaded_photos
    object.user.photos.order(order: :desc).map { |p| cdn_for p.image }
  end
end
