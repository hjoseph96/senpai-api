class Round < ApplicationRecord
  has_many :battles, dependent: :destroy
  belongs_to :tournament
end
