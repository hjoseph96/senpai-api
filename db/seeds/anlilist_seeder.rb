require 'open-uri'
require 'graphclient'

class AnilistSeeder
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

      response = @client.query @anime_query, { page: page, perPage: 100 }

      break unless response.original_hash['data']['Page']['pageInfo']['hasNextPage']

      anime_data = response.original_hash['data']['Page']['media']

      anime_data.each do |anime|
        next unless anime['title']['english'].present?

        puts "Page #{page}: Creating #{anime['title']['english']}... \n"

        attributes = {}

        attributes[:title] = anime['title']['english']
        attributes[:year] = anime['seasonYear']
        attributes[:genres] = anime['genres']
        attributes[:popularity] = anime['popularity']
        attributes[:average_score] = anime['averageScore']
        attributes[:episodes] = anime['episodes']
        attributes[:is_adult] = anime['isAdult']
        attributes[:status] = anime['status']
        attributes[:studios] = extract_studios(anime['studios'])
        attributes[:start_date] = extract_date(anime['startDate'])
        attributes[:end_date] = extract_date(anime['endDate'])

        saved_anime = Anime.create(attributes)

        next unless anime['coverImage']['large'].present?

        tmp_folder = File.dirname(__FILE__), '/tmp_imgs'
        filename = "#{anime['title']['english']}-#{i}"
        cover_dest = "#{tmp_folder.join}/#{anime['title']['english'].gsub(/^.*(\\|\/)/, '').gsub(/[^0-9A-Za-z.\-]/, '_')}-#{i}.png"
        File.open(cover_dest, 'wb') do |fo|
          fo.write URI.open(anime['coverImage']['large']).read
        end
        cover = File.open(cover_dest)
        saved_anime.cover_image.attach(io: cover, filename:  filename)
      end
    end

    FileUtils.rm_rf("#{Rails.root}/db/seeds/tmp_imgs/.", secure: true)
  end

  def extract_studios(data)
    h = { studios: [] }

    data['edges'].each { |studio_data| h[:studios] << studio_data['node'] }

    h.to_json
  end

  def extract_date(date)
    date['year'].present? ? Date.new(date['year']) : nil
  end
end