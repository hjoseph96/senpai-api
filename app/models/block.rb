class Block < ApplicationRecord
  belongs_to :report, optional: true
end
