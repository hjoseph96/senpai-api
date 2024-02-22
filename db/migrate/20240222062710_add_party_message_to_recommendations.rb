class AddPartyMessageToRecommendations < ActiveRecord::Migration[7.1]
  def change
    add_reference :recommendations, :party_message, foreign_key: true, null: true

  end
end
