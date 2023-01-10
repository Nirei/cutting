# frozen_string_literal: true

require_relative "cutting/version"
require_relative "cutting/example"

# Cutting is a Processing implementation done entirely in Ruby
module Cutting
  window = Example.new(1024, 768, "Cutting")
  window.main
  exit(0)
end
