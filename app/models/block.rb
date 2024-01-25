class Block < ApplicationRecord
  belongs_to :user
  belongs_to :report, optional: true
end
