# frozen_string_literal: true

class VideoMatchmaker

  def self.find_matches(user_id:)
    new.find_matches(user_id: user_id)
  end

  def find_matches(user_id:)
    @user = User.preload(:video_matches, :blocks).find(user_id)

    pool = User.where(awaiting_match: true)

    if @user.desires_women?
      pool = pool.where(gender: :female)
    elsif @user.desires_men?
      pool = pool.where(gender: :male)
    elsif @user.desires_both?
      pool = pool.where(gender: [:male, :female])
    end

    return [] unless pool.count > 0

    user_pool = randomize_users(pool)

    order_by_similarity(user_pool)
  end

  def randomize_users(pool)
    user_pool = []

    (50 - user_pool.count).times do
      u = pool.sample

      next if @user.has_video_matched?(u) || User.matched_with?(@user.matches, u) || User.blocked?(@user.blocks, u)
      
      next unless want_each_other?(@user, u)

      user_pool << u
    end

    ids = user_pool.map(&:id).uniq

    User.where(id: ids).preload(:animes)
  end

  def want_each_other?(user, other_user)
    if user.male?
      if other_user.female?
        likes_girls = user.desires_women? || user.desires_both?
        she_likes_men = other_user.desires_men? || other_user.desires_both?
        return likes_girls && she_likes_men
      end

      if other_user.male?
        likes_men = user.desires_men? || user.desires_both?
        he_likes_men = other_user.desires_men? || other_user.desires_both?
        return  likes_men && he_likes_men
      end
    elsif user.female?
      if other_user.female?
        likes_girls = user.desires_women? || user.desires_both?
        she_likes_women = other_user.desires_women? || other_user.desires_both?
        return likes_girls && she_likes_women
      end

      if other_user.male?
        likes_men = user.desires_men? || user.desires_both?
        he_likes_women = other_user.desires_women? || other_user.desires_both?
        return likes_men && he_likes_women
      end
    end
  end

  def order_by_similarity(user_pool)
    ranks = {}

    location_weight = 0.7

    user_pool.find_in_batches do |group|
      group.each do |u|
        distance = calculate_distance(u)

        ranks[u.id] = {
          distance: distance / location_weight,
          anime_similarity_score: anime_similarity_score(u)
        }
      end
    end

    feed = ranks.sort_by {|k, v| v[:distance] }.reverse.to_h
    feed = feed.sort_by {|k, v| v[:anime_similarity_score] }.reverse.to_h

    User.where(id: feed.keys).in_order_of(:id, feed.keys)
  end

  def calculate_distance(other_user)
    p1 = RGeo::Geographic.spherical_factory.point(@user.lonlat.longitude, @user.lonlat.latitude)

    p2 = RGeo::Geographic.spherical_factory.point(other_user.lonlat.longitude, other_user.lonlat.latitude)

    p1.distance(p2) / 1609.34
  end

  def anime_similarity_score(potential_match)
    same_taste_score = (@user.anime_ids & potential_match.anime_ids).count * 0.7

    user_genre_list = @user.animes.pluck(:genres).flatten.uniq
    match_genre_list = potential_match.animes.pluck(:genres).flatten.uniq
    same_genre_score = (user_genre_list & match_genre_list).count * 0.4

    score = same_genre_score + same_taste_score

    score *= 1.5 if potential_match.premium?

    score = score / 5

    return 1.0 if score > 1.0

    score
  end
end
