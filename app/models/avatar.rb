class Avatar < ApplicationRecord
  belongs_to :user, optional: true

  has_one_attached :photo
  has_one_attached :thumbnail

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name], using: { trigram: { threshold: 0.1 } }

  enum :gender, %i[male female]

  def clone!(user_id:)
    clone = self.clone

    clone.user_id = user_id

    clone.save!
  end
end
