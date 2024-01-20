class Like < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  enum :like_type, [ :standard, :super, :rejection ]
end
