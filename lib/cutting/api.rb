# frozen_string_literal: true

require_relative 'constants'

module Cutting
  module Api
    ### Shape

    #### 2D primitives

    # Draws an arc in the display window
    def arc(x, y, width, height, start, stop)
    end

    # Draws a circle to the screen
    def circle(x, y, radius)
      GL.Begin(GL::TRIANGLE_FAN)
      GL.Color4f(*context.fill)
      subdivision = 360
      subdivision.times do |index|
        theta = 2.0 * Math::PI * index / subdivision

        cx = radius * Math.cos(theta)
        cy = radius * Math.sin(theta)

        GL.Vertex3f(x + cx, y + cy, 0.0)
      end
      GL.End()
    end

    # Draws an ellipse (oval) in the display window
    def ellipse(x, y, width, height)
    end

    # Draws a line (a direct path between two points) to the screen
    def line(x1, y1, x2, y2)
    end

    # Draws a point, a coordinate in space at the dimension of one pixel
    def point(x1, y1)
    end

    # A quad is a quadrilateral, a four sided polygon
    def quad(x1, y1, x2, y2, x3, y3, x4, y4)
      GL.Begin(GL::QUADS)
      GL.Color4f(*context.fill)
      GL.Vertex3f(x1, y1, 0.0)
      GL.Vertex3f(x2, y2, 0.0)
      GL.Vertex3f(x3, y3, 0.0)
      GL.Vertex3f(x4, y4, 0.0)
      GL.End()
    end

    # Draws a rectangle to the screen
    def rect(x, y, width, height)
    end

    # Draws a square to the screen
    def square(x, y, side)
      x1, y1, x2, y2, x3, y3, x4, y4 =
        case context.rect_mode
        when Constants::CORNER, Constants::CORNERS
          [x, y, x + side, y, x + side, y + side, x, y + side]
        when Constants::RADIUS
          radius = side
          [
            x - radius,
            y - radius,
            x + radius,
            y - radius,
            x + radius,
            y + radius,
            x - radius,
            y + radius
          ]
        when Constants::CENTER
          radius = side / 2
          [
            x - radius,
            y - radius,
            x + radius,
            y - radius,
            x + radius,
            y + radius,
            x - radius,
            y + radius
          ]
        else
          raise ArgumentError, "unknown rectMode #{context.rect_mode}"
        end

      GL.Begin(GL::QUADS)
      GL.Color4f(*context.fill)
      GL.Vertex3f(x1, y1, 0.0)
      GL.Vertex3f(x2, y2, 0.0)
      GL.Vertex3f(x3, y3, 0.0)
      GL.Vertex3f(x4, y4, 0.0)
      GL.End()
    end

    # A triangle is a plane created by connecting three points
    def triangle(x1, y1, x2, y2, x3, y3)
      GL.Begin(GL::TRIANGLES)
      GL.Color4f(*context.fill)
      GL.Vertex3f(x1, y1, 0.0)
      GL.Vertex3f(x2, y2, 0.0)
      GL.Vertex3f(x3, y3, 0.0)
      GL.End()
    end

    #### Attributes

    # The origin of the ellipse is modified by the ellipseMode() function
    def ellipseMode(mode)
    end

    # Modifies the location from which rectangles draw
    def rectMode(mode)
    end

    # Sets the style for rendering line endings
    def strokeCap(cap)
    end

    # Sets the style of the joints which connect line segments
    def strokeJoin(join)
    end

    #Sets the width of the stroke used for lines, points, and the border around shapes
    def strokeWeight(weight)
    end

    ### Color

    # Extracts the alpha value from a color
    def alpha(color)
    end

    # Extracts the blue value from a color, scaled to match current colorMode()
    def blue(color)
    end

    # Extracts the brightness value from a color
    def brightness(color)
    end

    # Creates colors for storing in variables of the color datatype
    def color(c1, c2, c3, cA = nil)
    end

    # Extracts the green value from a color, scaled to match current colorMode()
    def green(color)
    end

    # Extracts the hue value from a color
    def hue(color)
    end

    # Calculates a color or colors between two colors at a specific increment
    def lerpColor(from, to, amount)
    end

    # Extracts the red value from a color, scaled to match current colorMode()
    def red(color)
    end

    # Extracts the saturation value from a color
    def saturation(color)
    end

    # Sets the color used for the background of the Processing window
    def background(c1, c2 = nil, c3 = nil)
      context.background = context.normalize_color(c1, c2, c3)
      GL.ClearColor(*context.background)

      clear()
    end

    # Clears the pixels within a buffer
    def clear()
      GL.Clear(GL::COLOR_BUFFER_BIT)
    end

    # Changes the way Processing interprets color data
    def colorMode(mode, max1, max2 = nil, max3 = nil, maxA = nil)
    end

    # Sets the color used to fill shapes
    def fill(c1, c2 = 0.0, c3 = 0.0, cA = context.max_alpha)
      context.fill = context.normalize_color(c1, c2, c3, cA)
    end

    # Disables filling geometry
    def noFill()
      context.fill = nil
    end

    # Disables drawing the stroke (outline)
    def noStroke()
      context.stroke = nil
    end

    # Sets the color used to draw lines and borders around shapes
    def stroke(c1, c2 = 0.0, c3 = 0.0, cA = context.max_alpha)
      context.stroke = context.normalize_color(c1, c2, c3, cA)
    end
  end
end
