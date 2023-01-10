# frozen_string_literal: true

require_relative "shape/primitives_2d"
require_relative "shape/attributes"

module Cutting
  module Api
    # API for drawing shapes
    module Shape
      include Shape::Primitives2D
      include Shape::Attributes
    end
  end
end
