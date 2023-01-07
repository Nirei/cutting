# frozen_string_literal: true

module Cutting
  class Context
    # Shape
    attr_accessor :ellipseMode
    attr_accessor :rectMode
    attr_accessor :strokeCap
    attr_accessor :strokeJoin
    attr_accessor :strokeWeight

    # Color
    attr_accessor :background
    attr_accessor :colorMode
    attr_accessor :fill
    attr_accessor :stroke
    
  end
end
