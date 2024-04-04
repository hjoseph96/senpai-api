class Battle < ApplicationRecord
  belongs_to :round

  belongs_to :blue_cornerable, polymorphic: true
  belongs_to :red_cornerable, polymorphic: true

  has_one_attached :discord_cover

  include ApplicationHelper

  after_create_commit :generate_discord_cover

  def voting_over?
    self.ends_at < DateTime.now
  end

  def winner
    return nil unless self.voting_over?

    if blue_corner_votes > red_corner_votes
      blue_cornerable
    elsif red_corner_votes >= blue_corner_votes
      red_cornerable
    end
  end

  def generate_discord_cover
    template_path = "#{Rails.root}/db/seeds/tournament_seeds/template.png"
    font_path = "#{Rails.root}/db/seeds/tournament_seeds/Roboto-Black.ttf"

    template = Magick::ImageList.new(template_path)
    text = Magick::Draw.new
    template.annotate(text, 700,95,595,425, Round.last.tournament.title) do |options|
      options.gravity = Magick::CenterGravity
      options.pointsize = 75
      options.fill = "#FFFFFF" # Font color
      options.font = font_path # Font file; needs to be absolute
      options.font_weight = Magick::NormalWeight
      template.format = "png"
    end

    red_corner_name = if self.red_cornerable.try(:first_name)
                        "#{self.red_cornerable.first_name} #{self.red_cornerable.last_name}"
                      else
                        self.red_cornerable.title
                      end

    blue_corner_name = if self.blue_cornerable.try(:first_name)
                        "#{self.blue_cornerable.first_name} #{self.blue_cornerable.last_name}"
                      else
                        self.blue_cornerable.title
                       end

    text = Magick::Draw.new
    template.annotate(text, 700,95,330,535, red_corner_name) do |options|
      options.gravity = Magick::CenterGravity
      options.pointsize = 46
      options.fill = "#FFFFFF" # Font color
      options.font = font_path # Font file; needs to be absolute
      options.font_weight = Magick::NormalWeight
      template.format = "png"
    end

    text = Magick::Draw.new
    template.annotate(text, 700,95,850,535, blue_corner_name) do |options|
      options.gravity = Magick::CenterGravity
      options.pointsize = 46
      options.fill = "#FFFFFF" # Font color
      options.font = font_path # Font file; needs to be absolute
      options.font_weight = Magick::NormalWeight
      template.format = "png"
    end

    red_corner_file = self.red_cornerable.try(:image) || self.red_cornerable.try(:cover_image)

    filename = "#{self.id}-#{red_corner_name}"
    cover_dest = "#{Rails.root}/tmp/#{filename}.png"

    File.open(cover_dest, 'wb') do |fo|
      fo.write HTTParty.get(cdn_for(red_corner_file)).body
    end

    red_corner_img = Magick::ImageList.new(cover_dest)
    template.composite!(red_corner_img, Magick::NorthWestGravity, 563, 611, Magick::OverCompositeOp)

    blue_corner_file = self.blue_cornerable.try(:image) || self.blue_cornerable.try(:cover_image)
    filename = "#{self.id}-#{blue_corner_name}"
    cover_dest = "#{Rails.root}/tmp/#{filename}.png"

    File.open(cover_dest, 'wb') do |fo|
      fo.write HTTParty.get(cdn_for(blue_corner_file)).body
    end

    blue_corner_img = Magick::ImageList.new(cover_dest)
    template.composite!(blue_corner_img, Magick::NorthWestGravity, 1098, 612, Magick::OverCompositeOp)

    cover_path = "#{Rails.root}/tmp/#{self.id}-discord-battle.png"
    template.write(cover_path)

    cover = File.open(cover_path)
    self.discord_cover.attach(io: cover, filename: "#{self.id}-discord-battle.png")
  end
end
