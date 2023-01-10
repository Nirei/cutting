# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Color
      # Allows easy manipulation of color values
      module CreatingReading
        # Extracts the alpha value from a color
        def alpha(_color)
          raise "not implemented"
        end

        # Extracts the blue value from a color, scaled to match current `color_mode()`
        def blue(_color)
          raise "not implemented"
        end

        # Extracts the brightness value from a color
        def brightness(_color)
          raise "not implemented"
        end

        # Creates colors for storing in variables of the color datatype
        def color(c1, c2, c3, ca = nil)
        end

        # Extracts the green value from a color, scaled to match current `color_mode()`
        def green(_color)
          raise "not implemented"
        end

        # Extracts the hue value from a color
        def hue(_color)
          raise "not implemented"
        end

        # Calculates a color or colors between two colors at a specific increment
        def lerp_color(_from, _to, _amount)
          raise "not implemented"
        end

        # Extracts the red value from a color, scaled to match current `color_mode()`
        def red(_color)
          raise "not implemented"
        end

        # Extracts the saturation value from a color
        def saturation(_color)
          raise "not implemented"
        end
      end
    end
  end
end
