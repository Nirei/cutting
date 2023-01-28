# frozen_string_literal: true

require_relative "api/shape"
require_relative "api/color"
require_relative "api/environment"
require_relative "api/input"
require_relative "api/output"

module Cutting
  # Implements the full Processing API
  module Api
    include Api::Shape
    include Api::Color
    include Api::Environment
    include Api::Input
    include Api::Output
  end
end
