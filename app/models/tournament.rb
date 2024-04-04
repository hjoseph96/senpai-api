class Tournament < ApplicationRecord
  include ApplicationHelper

  belongs_to :user, optional: true

  has_many :rounds, dependent: :destroy

  has_one_attached :cover_image
  has_one_attached :winner_image

  enum tournament_type: [:anime, :characters]
  enum combatant_count: %w[2 4 8 16 32]

  def generate_winner_image
    template_path = "#{Rails.root}/db/seeds/tournament_seeds/tournament_winner_template.png"
    font_path = "#{Rails.root}/db/seeds/tournament_seeds/Roboto-Black.ttf"

    template = Magick::ImageList.new(template_path)
    text = Magick::Draw.new
    template.annotate(text, 700,95,595,425, self.title) do |options|
      options.gravity = Magick::NorthWestGravity
      options.pointsize = 75
      options.fill = "#FFFFFF" # Font color
      options.font = font_path # Font file; needs to be absolute
      options.font_weight = Magick::NormalWeight
      template.format = "png"
    end
    winner = self.rounds.find_by(number: self.current_round).battles[0].winner

    winner_name = if winner.try(:first_name)
                         "#{winner.first_name} #{winner.last_name}"
                       else
                         winner.title
                       end

    text = Magick::Draw.new
    template.annotate(text, 700,95,590,990, winner_name) do |options|
      options.gravity = Magick::CenterGravity
      options.pointsize = 35
      options.fill = "#FFFFFF" # Font color
      options.font = font_path # Font file; needs to be absolute
      options.font_weight = Magick::NormalWeight
      template.format = "png"
    end

    winner_file = winner.try(:image) || winner.try(:cover_image)

    filename = "#{self.id}-#{winner_name}"
    cover_dest = "#{Rails.root}/tmp/#{filename}.png"

    File.open(cover_dest, 'wb') do |fo|
      fo.write HTTParty.get(cdn_for(winner_file)).body
    end

    winner_img = Magick::ImageList.new(cover_dest)
    template.composite!(winner_img, Magick::NorthWestGravity, 817, 646, Magick::OverCompositeOp)

    cover_path = "#{Rails.root}/tmp/#{self.id}-discord-winner.png"
    template.write(cover_path)

    cover = File.open(cover_path)
    self.winner_image.attach(io: cover, filename: "#{self.id}-discord-winner.png")
  end
end
