# rubocop:disable Metrics/ModuleLength
# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Shape
      # Contains 2D primitives like circles, rects...
      module Primitives2D
        # Draws an arc in the display window
        def arc(x, y, width, height, start, stop, _mode = Constants::OPEN)
          subdivision = 90
          theta = Constants::TAU / subdivision
          cos = Math.cos(theta)
          sin = Math.sin(theta)

          start_index = (subdivision * start) / Constants::TAU
          stop_index = (subdivision * stop) / Constants::TAU

          vertices =
            arc_vertices(
              subdivision: subdivision,
              x: x,
              y: y,
              width: width,
              height: height,
              start: start_index,
              stop: stop_index,
              sin: sin,
              cos: cos
            )

          # Fill
          GL.Begin(GL::TRIANGLE_FAN)
          GL.Color4f(*context.fill)
          vertices.each { |vertex| GL.Vertex3f(*vertex, 0.0) }
          GL.End

          # Contour
          GL.Begin(GL::TRIANGLE_STRIP)
          set_stroke
          outline_vertices(context.stroke_weight, *vertices).each { |vertex| GL.Vertex3f(*vertex, 0.0) }
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
          GL.Color4f(*context.stroke)
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
          vertices = [[x1, y1], [x2, y2], [x3, y3], [x4, y4]]

          GL.Begin(GL::QUADS)
          set_fill
          vertices.each { |vertex| GL.Vertex3f(*vertex, 0.0) }
          GL.End

          GL.Begin(GL::TRIANGLE_STRIP)
          set_stroke
          outline_vertices(context.stroke_weight, *vertices).each { |vertex| GL.Vertex3f(*vertex, 0.0) }
          GL.End
        end

        # Draws a rectangle to the screen
        def rect(x, y, width, height)
          vertices =
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

          quad(*vertices)
        end

        # Draws a square to the screen
        def square(x, y, side)
          rect(x, y, side, side)
        end

        # A triangle is a plane created by connecting three points
        def triangle(x1, y1, x2, y2, x3, y3)
          # Fill
          GL.Begin(GL::TRIANGLES)
          GL.Color4f(*context.fill)
          GL.Vertex3f(x1, y1, 0.0)
          GL.Vertex3f(x2, y2, 0.0)
          GL.Vertex3f(x3, y3, 0.0)
          GL.End
        end

        private

        def set_fill
          GL.Color4f(*context.fill)
        end

        def set_stroke
          GL.Color4f(*context.stroke)
        end

        def arc_vertices(subdivision:, x:, y:, width:, height:, start:, stop:, sin:, cos:)
          px = 1
          py = 0

          output = []

          subdivision.times do |index|
            output << [(px * width) + x, (py * height) + y] if (index >= start) && (index < stop)

            tempx = px
            px = (cos * px) - (sin * py)
            py = (sin * tempx) + (cos * py)
          end

          output
        end

        def outline_vertices(weight, *vertices)
          output = []

          vertices.each_index do |index|
            prev_vertex = vertices[index - 1]
            current_vertex = vertices[index]
            next_vertex = vertices[(index + 1) % vertices.size]
            outline_vertex = parallel_intersection(prev_vertex, current_vertex, next_vertex, weight)

            output << current_vertex
            output << outline_vertex
          end

          prev_vertex = vertices[-1]
          current_vertex = vertices.first
          next_vertex = vertices[1]
          outline_vertex = parallel_intersection(prev_vertex, current_vertex, next_vertex, weight)
          output << current_vertex
          output << outline_vertex
        end

        # Given two lines, calculate parallels at wa given distance for each of them, then calculate the intersection of
        # those parallels. This is useful to draw contours for objects.
        def parallel_intersection(prev_vertex, current_vertex, next_vertex, distance)
          xa, ya = prev_vertex
          xb, yb = current_vertex
          xc, yc = next_vertex

          _parallel_ab_xa, _parallel_ab_ya, parallel_ab_xb, parallel_ab_yb = parallel(xa, ya, xb, yb, distance)
          parallel_bc_xb, parallel_bc_yb, _parallel_bc_xc, _parallel_bc_yc = parallel(xb, yb, xc, yc, distance)

          dir_ab_x = xb - xa
          dir_ab_y = yb - ya
          dir_bc_x = xc - xb
          dir_bc_y = yc - yb

          matrix = [
            [dir_ab_x, 0.0, -1.0, 0],
            [dir_ab_y, 0.0, 0.0, -1.0],
            [0.0, dir_bc_x, -1.0, 0.0],
            [0.0, dir_bc_y, 0.0, -1.0]
          ]

          return parallel_ab_xb, parallel_ab_yb if determinant(matrix).abs < Float::EPSILON

          values = [-parallel_ab_xb, -parallel_ab_yb, -parallel_bc_xb, -parallel_bc_yb]

          _lambda_ab, _lambda_bc, x, y = solve_gaussian(matrix, values)

          [x, y]
        end

        # Calculate two points on a parallel line at a given distance
        def parallel(xa, ya, xb, yb, distance)
          normal_x = yb - ya
          normal_y = xa - xb
          unit_x, unit_y = unit_vector(normal_x, normal_y)
          distance_x = distance * unit_x
          distance_y = distance * unit_y
          parallel_xa = xa + distance_x
          parallel_ya = ya + distance_y
          parallel_xb = xb + distance_x
          parallel_yb = yb + distance_y
          [parallel_xa, parallel_ya, parallel_xb, parallel_yb]
        end

        def unit_vector(x, y)
          modulo = vector_magnitude(x, y)
          [x / modulo, y / modulo]
        end

        def vector_magnitude(x, y)
          Math.sqrt((x**2) + (y**2))
        end

        # Finds the solution to a system of ecuations using Gaussian elimination
        def solve_gaussian(matrix, solution) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          n = matrix.length
          (0...n - 1).each do |i|
            # Find the pivot element
            pivot = i
            (i + 1...n).each { |j| pivot = j if matrix[j][i].abs > matrix[pivot][i].abs }
            # Swap rows if pivot is not on the diagonal
            if pivot != i
              matrix[i], matrix[pivot] = matrix[pivot], matrix[i]
              solution[i], solution[pivot] = solution[pivot], solution[i]
            end
            # Elimination
            (i + 1...n).each do |j|
              m = matrix[j][i] / matrix[i][i]
              matrix[j][i] = 0
              (i + 1...n).each { |k| matrix[j][k] -= m * matrix[i][k] }
              solution[j] -= m * solution[i]
            end
          end
          # Back Substitution
          x = Array.new(n)
          x[n - 1] = solution[n - 1] / matrix[n - 1][n - 1]
          (n - 2)
            .downto(0)
            .each do |i|
              sum = solution[i]
              (i + 1...n).each { |j| sum -= matrix[i][j] * x[j] }
              x[i] = sum / matrix[i][i]
            end
          x
        end

        # Finds the determinant of a matrix of arbitrary size
        def determinant(matrix)
          length = matrix.length
          if length == 3
            return(
              (matrix[0][0] * matrix[1][1] * matrix[2][2]) + (matrix[0][1] * matrix[1][2] * matrix[2][0]) +
                (matrix[0][2] * matrix[1][0] * matrix[2][1]) - (matrix[0][0] * matrix[1][2] * matrix[2][1]) -
                (matrix[0][1] * matrix[1][0] * matrix[2][2]) - (matrix[0][2] * matrix[1][1] * matrix[2][0])
            )
          end
          return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0]) if length == 2
          return matrix[0][0] if length == 1

          det = 0
          sign = 1

          (0...length).each do |index|
            sub_matrix = matrix[1..].map { |row| row[0...index] + row[index + 1..] }
            det += sign * matrix[0][index] * determinant(sub_matrix)
            sign *= -1
          end

          det
        end
      end
    end
  end
end

# rubocop:enable Metrics/ModuleLength
