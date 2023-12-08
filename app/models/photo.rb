class Photo < ApplicationRecord
  belongs_to :gallery, dependent: :destroy

  has_one_attached :image
end
