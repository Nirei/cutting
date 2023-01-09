# frozen_string_literal: true

require_relative 'constants'

module Cutting
  class Context
    def initialize
      @ellipse_mode = Constants::CENTER
      @rect_mode = Constants::CORNER
      @stroke_cap = Constants::ROUND
      @stroke_join = Constants::MITER
      @stroke_weight = 4

      @color_channel_maximums = [255.0, 255.0, 255.0, 255.0]
      @background = normalize_color(211.0, 211.0, 211.0)
      @fill = normalize_color(0.0, 0.0, 0.0)
      @color_mode = Constants::RGB
    end

    def normalize_color(
      c1 = 0.0,
      c2 = 0.0,
      c3 = 0.0,
      cA = max_alpha
    )
      [c1, c2, c3, cA].zip(color_channel_maximums)
        .map { |channel, maximum| channel / maximum }
    end

    def max_alpha
      color_channel_maximums[3]
    end

    # Shape
    attr_accessor :ellipse_mode
    attr_accessor :rect_mode
    attr_accessor :stroke_cap
    attr_accessor :stroke_join
    attr_accessor :stroke_weight

    # Color
    attr_accessor :color_channel_maximums
    attr_accessor :background
    attr_accessor :color_mode
    attr_accessor :fill
    attr_accessor :stroke
  end
end
