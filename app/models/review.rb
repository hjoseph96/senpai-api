class Review < ApplicationRecord
  belongs_to :user

  belongs_to :reviewable, polymorphic: true

  enum :review_type, [:party_member, :host, :convention]
end
