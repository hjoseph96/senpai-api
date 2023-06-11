class Like < ApplicationRecord
  belongs_to :user

  enum :like_type, [ :standard, :super, :rejection ]
end
