# frozen_string_literal: true

require_relative "api/shape"
require_relative "api/color"
require_relative "api/environment"

module Cutting
  # Implements the full Processing API
  module Api
    include Api::Shape
    include Api::Color
    include Api::Environment
  end
end
