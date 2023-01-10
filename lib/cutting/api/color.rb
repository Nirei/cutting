# frozen_string_literal: true

require_relative "color/creating_reading"
require_relative "color/setting"

module Cutting
  module Api
    # API for dealing with colors
    module Color
      include Color::CreatingReading
      include Color::Setting
    end
  end
end
