require 'open-uri'
require 'graphlient'

class AnilistSeeder
  include ActiveSupport::Inflector

  def self.create_animes
    new.parse_all_pages
  end

  def initialize
    @client = Graphlient::Client.new('https://graphql.anilist.co',
                                     http_options: {
                                         read_timeout: 20,
                                         write_timeout: 30
                                     }
    )
    @page_query = <<~GRAPHQL
      query ($id: Int, $page: Int, $perPage: Int) {
        	Page (page: $page, perPage: $perPage) {
            pageInfo {
              total
              currentPage
              lastPage
              hasNextPage
              perPage
            }
            media (id: $id, type: ANIME) {
        			id
            }
          }
        }
    GRAPHQL
    @anime_query = <<~GRAPHQL
      query ($id: Int, $page: Int, $perPage: Int) {
      	Page (page: $page, perPage: $perPage) {
          pageInfo {
            total
            currentPage
            lastPage
            hasNextPage
            perPage
          }
          media (id: $id, type: ANIME) {
      			id
      			title {
      				english
              native
      			}
            characters(page: 1) {
              edges { # Array of character edges
                node { # Character node
                  id
                  image { large }
                  name {
                    first
                    last
                    native
                  }
                  favourites
                  gender
                }
                role
              }
            }
      			seasonYear
      			genres
      			popularity
      			averageScore
      			episodes
      			isAdult
      			status
      			studios {
      				edges {
      					node {
      						name
      						isAnimationStudio
      					}
      				}
      			}
      			startDate {
      				year
      				day
      				month
      			}
      			endDate {
      				year
      				day
      				month
      			}
      			coverImage {
      				large
      			}
          }
        }
      }
    GRAPHQL
  end

  def parse_all_pages
    response = @client.query @page_query, { page: 1, perPage: 100 }

    total_pages = response.original_hash['data']['Page']['pageInfo']['total']
    total_pages.times do |i|
      page = i + 1

      begin
        response = @client.query @anime_query, { page: page, perPage: 100 }
      rescue Graphlient::Errors::FaradayServerError
        sleep(60)
        response = @client.query @anime_query, { page: page, perPage: 100 }
      end

      break unless response.original_hash['data']['Page']['pageInfo']['hasNextPage']

      anime_data = response.original_hash['data']['Page']['media']


      anime_data.each do |anime|
        next unless anime['title']['english'].present?

        attributes = {}

        attributes[:title] = anime['title']['english']
        next if Anime.exists?(title: attributes[:title])

        puts "Page #{page}: Creating #{anime['title']['english']}... \n"
        
        attributes[:year] = anime['seasonYear']
        attributes[:genres] = anime['genres']
        attributes[:popularity] = anime['popularity']
        attributes[:average_score] = anime['averageScore']
        attributes[:episodes] = anime['episodes']
        attributes[:is_adult] = anime['isAdult']
        attributes[:status] = anime['status']
        attributes[:japanese_title] = anime['title']['native']
        attributes[:studios] = extract_studios(anime['studios'])
        attributes[:start_date] = extract_date(anime['startDate'])
        attributes[:end_date] = extract_date(anime['endDate'])

        saved_anime = Anime.create(attributes)

        extract_characters(anime, saved_anime)

        next unless anime['coverImage']['large'].present?

        tmp_folder = File.dirname(__FILE__), '/tmp_imgs'
        filename = "#{anime['title']['english']}-#{i}"
        cover_dest = "#{tmp_folder.join}/#{anime['title']['english'].gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_')}-#{i}.png"

        File.open(cover_dest, 'wb') do |fo|
          fo.write HTTParty.get(anime['coverImage']['large']).body
        end
        
        cover = File.open(cover_dest)
        saved_anime.cover_image.attach(io: cover, filename:  filename)
      end
    end

    FileUtils.rm_rf("#{Rails.root}/db/seeds/tmp_imgs/.", secure: true)
    FileUtils.touch("#{Rails.root}/db/seeds/tmp_imgs/.keep")
  end

  def extract_studios(data)
    h = { studios: [] }

    data['edges'].each { |studio_data| h[:studios] << studio_data['node'] }

    h.to_json
  end

  def extract_date(date)
    date['year'].present? ? Date.new(date['year']) : nil
  end

  def extract_characters(anime_data, created_anime)
    lit_characters = anime_data['characters']['edges'].reject {|c| c['node']['favourites'] < 100 }

    lit_characters.sort_by! {|h| h['node']['favourites'] }.reverse

    lit_characters.each_with_index do |c, i|
      character = c['node']

      next if Character.exists?(first_name: character['name']['first'], last_name: character['name']['last'])

      puts "Creating #{character['name']['first']} from #{created_anime.title}."

      gender = nil
      gender = :male if c['gender'] == 'Male'
      gender = :female if c['gender'] == 'Female'

      char = Character.create!(
        anime_id: created_anime.id,
        role: c['role'],
        gender: gender,
        first_name: character['name']['first'],
        last_name: character['name']['last'],
        japanese_full_name: character['name']['native'],
        favorites: character['favourites'],
      )

      tmp_folder = File.dirname(__FILE__), '/tmp_imgs'
      cover_dest = "#{tmp_folder.join}/#{parameterize(created_anime.title)}-#{char.first_name}-#{i}.png"
      File.open(cover_dest, 'wb') do |fo|
        fo.write HTTParty.get(c['node']['image']['large']).body
      end

      image = File.open(cover_dest)
      char.image.attach(io: image, filename:  "#{char.first_name}_from_#{parameterize(created_anime.title)}-#{created_anime.id}")
    end
  end
end