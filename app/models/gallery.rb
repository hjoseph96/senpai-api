class Gallery < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :photos, dependent: :destroy

  def update_photo_order!
    self.photos.each_with_index { |p, i| p.update!(order: i)  }
  end
end
