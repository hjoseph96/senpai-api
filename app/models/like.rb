class Like < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_one :likee

  enum :like_type, [ :standard, :super, :rejection ]
end
