class Like < ApplicationRecord
  belongs_to :user
  has_one :user_like, dependent: :destroy

  enum :like_type, [ :standard, :super, :rejection ]
end
