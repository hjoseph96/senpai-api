class Character < ApplicationRecord
  belongs_to :anime

  has_one_attached :image

  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: [:first_name, :last_name, :japanese_full_name]
end
