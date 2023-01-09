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
      fill(0.0, 0.0, 0.0)
      circle(100.0, 100.0, 50.0)
      square(200.0, 200.0, 50.0)
    end
  end
end
