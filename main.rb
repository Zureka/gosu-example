require 'gosu'
require_relative './player'
require_relative './star'

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Tutorial < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Tutorial Game"
    @font = Gosu::Font.new(20)

    @background_image = Gosu::Image.new("media/space.png", tileable: true)

    @player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = []
  end

  def update
    @player.turn_left if Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::GP_LEFT)
    @player.turn_right if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::GP_RIGHT)
    @player.accelerate if Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::GP_BUTTON_0)

    @player.move
    @player.collect_stars(@stars)

    @stars.push(Star.new(@star_anim)) if rand(100) < 4 && @stars.size < 25
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    @player.draw
    @stars.each(&:draw)
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Tutorial.new.show
