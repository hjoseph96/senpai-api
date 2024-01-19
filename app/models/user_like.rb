class UserLike < ApplicationRecord
    acts_as_paranoid

    belongs_to :user
    belongs_to :like
end