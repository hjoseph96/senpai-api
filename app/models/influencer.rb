class Influencer < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user

  has_one_attached :qr_code

  after_create

  def generate_qr_code
    #   TODO
  end
end
