# frozen_string_literal: true

module Cutting
  ### Misc
  TAU = Math::PI * 2.0
  TWO_PI = TAU
  HALF_TAU = Math::PI
  PI = HALF_TAU
  QUARTER_TAU = Math::PI / 2.0
  HALF_PI = QUARTER_TAU
  EIGTH_TAU = Math::PI / 4.0
  QUARTER_PI = EIGTH_TAU

  ### Shape
  CENTER = :center
  RADIUS = :radius
  CORNER = :corner
  CORNERS = :corners

  SQUARE = :square
  PROJECT = :project
  ROUND = :round
  MITER = :miter
  BEVEL = :bevel

  #### Arc drawing modes
  PIE = :pie
  OPEN = :open
  CHORD = :chord

  ### Color
  RGB = :rgb
  HSB = :hsb
end
