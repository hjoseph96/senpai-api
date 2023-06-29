class Report < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  enum :reason, [:inappropriate_behavior, :spam, :sexual_abuse, :doxxing]
end
