class Referral < ApplicationRecord
  belongs_to :referer, foreign_key: :referer_id, class_name: 'User'
  belongs_to :referee, foreign_key: :referred_id, class_name: 'User'
end
