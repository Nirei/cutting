# frozen_string_literal: true

require_relative 'window'
require_relative 'api'

module Cutting
  class Example < Window
    include Api
    def setup
    end

    def draw
      clear()
      5.times do |col|
        fill(Random.rand(255.0), Random.rand(255.0), Random.rand(255.0))
        square(col*100, 300.0, 50.0)
      end
      fill(0.0, 0.0, 0.0)
      circle(100.0, 100.0, 50.0)
      square(200.0, 200.0, 50.0)
    end
  end
end
