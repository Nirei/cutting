# frozen_string_literal: true

require "cutting"

# Made for Genuary 4, 2023
class Intersections < Cutting::Window
  def initialize
    super("Intersections")
  end

  def setup
    size(400, 400)
    no_stroke
    rect_mode(Cutting::CENTER)
    amount = 10
    @rectangles =
      (0..amount).flat_map do |x|
        (0..amount).map do |y|
          OscillatingRectangle.new(
            x: x * width / amount,
            y: y * height / amount,
            max_width: 50,
            max_height: 50,
            speed: Random.rand(100..300),
            tone_speed: Random.rand(10..100),
            tone_phase: Random.rand(0..Cutting::TAU)
          )
        end
      end
  end

  def draw
    clear

    @rectangles.each do |rectangle|
      fill(rectangle.tone, rectangle.tone, rectangle.tone, 128)
      rectangle.update(millis)
      rect(rectangle.x, rectangle.y, rectangle.width, rectangle.height)
    end

    # save_frame
    # exit 0 if frame_count == 599
  end

  # Draws a rectangle that grows and shrinks cyclically
  class OscillatingRectangle
    def initialize(x:, y:, max_width:, max_height:, speed:, tone_speed:, tone_phase:)
      @x = x
      @y = y
      @max_width = max_width
      @max_height = max_height
      @speed = speed
      @tone_speed = tone_speed
      @tone_phase = tone_phase
      @factor = 1
      @tone_factor = 1
    end

    def update(millis)
      radians = Cutting::TAU * millis
      self.factor = Math.cos(radians * speed / 1_000_000)
      self.tone_factor = Math.cos(tone_phase + (radians * tone_speed / 1_000_000))
    end

    def width
      factor * max_width
    end

    def height
      factor * max_height
    end

    def tone
      tone_factor * 255
    end

    attr_accessor :x
    attr_accessor :y
    attr_accessor :max_width
    attr_accessor :max_height
    attr_accessor :speed
    attr_accessor :tone_speed
    attr_accessor :tone_phase

    private

    attr_accessor :factor
    attr_accessor :tone_factor
  end
end

Intersections.new.main
