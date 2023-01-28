# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Shape
      # Allows setting shape-drawing attributes
      module Attributes
        VALID_SHAPE_MODES = [CENTER, RADIUS, CORNER, CORNERS].freeze

        # The origin of the ellipse is modified by the `ellipse_mode()` function
        def ellipse_mode(mode)
          raise ArgumentError, "unknown ellipse mode #{mode}" unless VALID_SHAPE_MODES.include?(mode)

          context.ellipse_mode = mode
        end

        # Modifies the location from which rectangles draw
        def rect_mode(mode)
          raise ArgumentError, "unknown rect mode #{mode}" unless VALID_SHAPE_MODES.include?(mode)

          context.rect_mode = mode
        end

        VALID_STROKE_CAPS = [SQUARE, PROJECT, ROUND].freeze

        # Sets the style for rendering line endings
        def stroke_cap(cap)
          raise ArgumentError, "unknown stroke cap #{cap}" unless VALID_STROKE_CAPS.include?(cap)

          context.stroke_cap = cap
        end

        VALID_STROKE_JOINS = [MITER, BEVEL, ROUND].freeze

        # Sets the style of the joints which connect line segments
        def stroke_join(join)
          raise ArgumentError, "unknown stroke join #{join}" unless VALID_STROKE_CAPS.include?(join)

          context.stroke_join = join
        end

        # Sets the width of the stroke used for lines, points, and the border around shapes
        def stroke_weight(weight)
          context.stroke_weight = weight
        end
      end
    end
  end
end
