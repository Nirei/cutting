# frozen_string_literal: true

require_relative "cutting/version"
require_relative "cutting/window"

module Cutting
  window = Window.new(1024, 768, 'Cutting')
  window.main
  exit(0)
end
