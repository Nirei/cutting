# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Shape
      # Contains 2D primitives like circles, rects...
      module Primitives2D
        # Draws an arc in the display window
        def arc(x, y, width, height, start, stop, _mode = Constants::OPEN)
          subdivision = 360
          theta = Constants::TAU / subdivision
          cos = Math.cos(theta)
          sin = Math.sin(theta)

          px = 1
          py = 0
          start_index = (subdivision * start) / Constants::TAU
          stop_index = (subdivision * stop) / Constants::TAU

          GL.Begin(GL::TRIANGLE_FAN)
          GL.Color4f(*context.fill)
          subdivision.times do |index|
            GL.Vertex3f((px * width) + x, (py * height) + y, 0.0) if (index >= start_index) && (index < stop_index)

            tempx = px
            px = (cos * px) - (sin * py)
            py = (sin * tempx) + (cos * py)
          end
          GL.End
        end

        # Draws a circle to the screen
        def circle(x, y, radius)
          ellipse(x, y, radius, radius)
        end

        # Draws an ellipse (oval) in the display window
        def ellipse(x, y, width, height)
          arc(x, y, width, height, 0.0, Constants::TAU)
        end

        # Draws a line (a direct path between two points) to the screen
        def line(x1, y1, x2, y2)
          GL.Begin(GL::LINES)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x1, y1, 0.0)
          GL.Vertex3f(x2, y2, 0.0)
          GL.End
        end

        # Draws a point, a coordinate in space at the dimension of one pixel
        def point(x, y)
          GL.Begin(GL::POINTS)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x, y, 0.0)
          GL.End
        end

        # A quad is a quadrilateral, a four sided polygon
        def quad(x1, y1, x2, y2, x3, y3, x4, y4)
          GL.Begin(GL::QUADS)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x1, y1, 0.0)
          GL.Vertex3f(x2, y2, 0.0)
          GL.Vertex3f(x3, y3, 0.0)
          GL.Vertex3f(x4, y4, 0.0)
          GL.End
        end

        # Draws a rectangle to the screen
        def rect(x, y, width, height)
          x1, y1, x2, y2, x3, y3, x4, y4 =
            case context.rect_mode
            when Constants::CORNER
              [x, y, x + width, y, x + width, y + height, x, y + height]
            when Constants::CORNERS
              [x, y, width, y, width, height, x, height]
            when Constants::RADIUS
              xradius = width
              yradius = height
              [x - xradius, y - yradius, x + xradius, y - yradius, x + xradius, y + yradius, x - xradius, y + yradius]
            when Constants::CENTER
              xradius = width / 2
              yradius = height / 2
              [x - xradius, y - yradius, x + xradius, y - yradius, x + xradius, y + yradius, x - xradius, y + yradius]
            else
              raise ArgumentError, "unknown rectMode #{context.rect_mode}"
            end

          GL.Begin(GL::QUADS)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x1, y1, 0.0)
          GL.Vertex3f(x2, y2, 0.0)
          GL.Vertex3f(x3, y3, 0.0)
          GL.Vertex3f(x4, y4, 0.0)
          GL.End
        end

        # Draws a square to the screen
        def square(x, y, side)
          rect(x, y, side, side)
        end

        # A triangle is a plane created by connecting three points
        def triangle(x1, y1, x2, y2, x3, y3)
          GL.Begin(GL::TRIANGLES)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x1, y1, 0.0)
          GL.Vertex3f(x2, y2, 0.0)
          GL.Vertex3f(x3, y3, 0.0)
          GL.End
        end
      end
    end
  end
end
