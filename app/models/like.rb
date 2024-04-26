class Like < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :likee, foreign_key: :likee_id, class_name: 'User'

  enum :like_type, [ :standard, :super, :rejection ]
end
