class Avatar < ApplicationRecord
  belongs_to :user, optional: true

  has_one_attached :photo
  has_one_attached :thumbnail
end
