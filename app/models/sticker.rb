class Sticker < ApplicationRecord
    has_many :messages
    
    has_one_attached :image
end
