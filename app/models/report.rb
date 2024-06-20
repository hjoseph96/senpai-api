class Report < ApplicationRecord
  belongs_to :user
  belongs_to :offender, foreign_key: :offense_id, class_name: 'User'
  belongs_to :conversation
  has_one :block, dependent: :destroy

  enum :status, [:open, :resolved]
  enum :reason, [:inappropriate_behavior, :spam, :catfish, :sexual_abuse, :doxxing]
end
