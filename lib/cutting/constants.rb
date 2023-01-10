# frozen_string_literal: true

module Cutting
  module Constants
    ### Misc
    TAU = Math::PI * 2

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
end
