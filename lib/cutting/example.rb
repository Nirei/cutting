# frozen_string_literal: true

require_relative "window"
require_relative "api"

module Cutting
  # Some examples to test functionality
  class Example < Window
    include Api
    def setup
    end

    def draw
      clear
      5.times do |col|
        fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
        square(col * 100, 600.0, 50.0)
      end
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      circle(100.0, 100.0, 50.0)
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      square(200.0, 200.0, 50.0)
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      ellipse(300.0, 300.0, 100.0, 50.0)
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      arc(400.0, 400.0, 50.0, 25.0, 1.0 / 7.0 * Math::PI, 6.0 / 4.0 * Math::PI)
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      line(500.0, 500.0, 500.0, 1000.0)
      fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
      point(100.0, 500.0)
    end
  end
end
