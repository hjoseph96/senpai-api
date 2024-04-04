class TournamentSeeder
  def self.create_tournaments
    new.create_tournaments
  end

  def create_tournaments
    whos_the_strongest
  end

  def whos_the_strongest
    begin
      popular_character_ids = Anime.where('popularity > 10000')
                                   .search_by_genre("Action")
                                   .shuffle[0..70]
                                   .map(&:character_ids)
                                   .flatten

      character_pool = Character.where(id: popular_character_ids).where('favorites > ?', 2000).to_a.shuffle

      tourney = Tournament.create(
        title: "Who's the strongest?",
        tournament_type: :characters,
        combatant_count: '16',
        hours_duration: 72,
        current_round: 1
      )

      r = Round.create(number: 1, tournament_id: tourney.id)

      (tourney.combatant_count.to_i / 2).times do |i|
        red_corner = character_pool.pop
        blue_corner = character_pool.pop

        b = Battle.new(round_id: r.id, battle_index: i + 1)
        b.red_cornerable = red_corner
        b.blue_cornerable = blue_corner
        b.save!
      end
    rescue ActiveRecord::RecordInvalid
      Tournament.destroy_all

      whos_the_strongest
    end


  end
end