# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Color
      # Allows defining color values for stroke, fill, background
      module Setting
        # Sets the color used for the background of the Processing window
        def background(c1, c2 = nil, c3 = nil)
          context.background = context.normalize_color(c1, c2, c3)
          GL.ClearColor(*context.background)

          clear
        end

        # Clears the pixels within a buffer
        def clear
          GL.Clear(GL::COLOR_BUFFER_BIT)
        end

        VALID_COLOR_MODES = [RGB, HSB].freeze

        # Changes the way Processing interprets color data
        def color_mode(mode, max1, max2 = nil, max3 = nil, max_alpha = nil)
          raise ArgumentError, "unknown color mode #{mode}" unless VALID_COLOR_MODES.contain(mode)

          context.color_mode = mode
          context.color_channel_maximums = [max1, max2, max3, max_alpha]
        end

        # Sets the color used to fill shapes
        def fill(c1, c2 = 0.0, c3 = 0.0, ca = context.max_alpha)
          context.fill = context.normalize_color(c1, c2, c3, ca)
        end

        # Disables filling geometry
        def no_fill
          fill(0.0, 0.0, 0.0, 0.0)
        end

        # Disables drawing the stroke (outline)
        def no_stroke
          stroke(0.0, 0.0, 0.0, 0.0)
        end

        # Sets the color used to draw lines and borders around shapes
        def stroke(c1, c2 = 0.0, c3 = 0.0, ca = context.max_alpha)
          context.stroke = context.normalize_color(c1, c2, c3, ca)
        end
      end
    end
  end
end
