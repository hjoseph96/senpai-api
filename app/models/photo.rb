class Photo < ApplicationRecord
  acts_as_paranoid

  belongs_to :gallery

  has_one_attached :image
end
