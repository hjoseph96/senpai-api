class PartyChat < ApplicationRecord
  belongs_to :party

  has_many :messages, foreign_key: :party_chat_id, class_name: 'PartyMessage'
end
