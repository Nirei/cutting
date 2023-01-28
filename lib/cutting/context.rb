# frozen_string_literal: true

require_relative "constants"

module Cutting
  # Stores context information for a Cutting::Window. This includes things like current background, color and stroke
  # config among other things.
  class Context
    def initialize
      @ellipse_mode = Constants::CENTER
      @rect_mode = Constants::CORNER
      @stroke_cap = Constants::ROUND
      @stroke_join = Constants::MITER
      @stroke_weight = 4

      @color_channel_maximums = [255.0, 255.0, 255.0, 255.0]
      @background = normalize_color(204.0, 204.0, 204.0)
      @stroke = normalize_color(0.0, 0.0, 0.0)
      @fill = normalize_color(0.0, 0.0, 0.0)
      @color_mode = Constants::RGB

      @start_time = Time.new

      @frame_rate = 10
      @frame_last_time = Time.new
      @frame_count = 0
      @width = 1024
      @height = 768

      @saved_frames = []
    end

    def normalize_color(c1 = 0.0, c2 = 0.0, c3 = 0.0, ca = max_alpha)
      [c1, c2, c3, ca].zip(color_channel_maximums).map { |channel, maximum| channel / maximum }
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

    # Environment
    attr_accessor :frame_rate
    attr_accessor :frame_last_time
    attr_accessor :frame_count
    attr_accessor :width
    attr_accessor :height

    # Input
    attr_reader :start_time
    
    # Output
    attr_accessor :saved_frames
  end
end
