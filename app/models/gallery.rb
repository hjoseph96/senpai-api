class Gallery < ApplicationRecord
  belongs_to :user
  has_many :photos

  def update_photo_order!
    self.photos.each_with_index { |p, i| p.update!(order: i)  }
  end
end
