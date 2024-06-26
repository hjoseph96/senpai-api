class TournamentSeeder
  def self.create_tournaments
    new.create_tournaments
  end

  def create_tournaments
    whos_the_strongest
    whos_the_cutest

    Dir.glob("#{Rails.root}/tmp/*").each do |file|
      File.delete(file) if File.basename(file).include?('.png')
    end
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

      last_end_date = 1.hours.from_now
      (tourney.combatant_count.to_i / 2).times do |i|
        red_corner = character_pool.pop
        blue_corner = character_pool.pop

        last_end_date = last_end_date + 1.hours if i > 0

        b = Battle.new(round_id: r.id, battle_index: i + 1, ends_at: last_end_date)
        b.red_cornerable = red_corner
        b.blue_cornerable = blue_corner
        b.save!
      end
    rescue ActiveRecord::RecordInvalid
      Tournament.last.destroy

      whos_the_strongest
    end
  end

  def whos_the_cutest
    begin
      popular_character_ids = Anime.where('popularity > 10000')
                                   .map(&:character_ids)
                                   .flatten

      character_pool = Character.where(id: popular_character_ids)
                                .where('favorites > ?', 2000)
                                .where(gender: :female).to_a.shuffle

      tourney = Tournament.create(
        title: "Who's the cutest?",
        tournament_type: :characters,
        combatant_count: '16',
        hours_duration: 6,
        current_round: 1
      )

      r = Round.create(number: 1, tournament_id: tourney.id)

      last_end_date = 1.hours.from_now
      (tourney.combatant_count.to_i / 2).times do |i|
        red_corner = character_pool.pop
        blue_corner = character_pool.pop

        last_end_date = last_end_date + 1.hours if i > 0

        b = Battle.new(round_id: r.id, battle_index: i + 1, ends_at: last_end_date)
        b.red_cornerable = red_corner
        b.blue_cornerable = blue_corner
        b.save!
      end
    rescue ActiveRecord::RecordInvalid
      Tournament.last.destroy

      whos_the_cutest
    end
  end
end