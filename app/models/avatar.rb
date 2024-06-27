class Avatar < ApplicationRecord
  belongs_to :user, optional: true

  has_one_attached :photo
  has_one_attached :thumbnail

  include PgSearch::Model

  pg_search_scope :search_by_name, against: [:name], using: { trigram: { threshold: 0.1 } }

end
