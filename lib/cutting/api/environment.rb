# frozen_string_literal: true

require_relative "../constants"

module Cutting
  module Api
    # API for reading and manipulating the environment
    module Environment
      # Sets the cursor to a predefined symbol, an image, or makes it visible if already hidden
      def cursor
        raise "not implemented"
      end

      # The `delay()` function causes the program to halt for a specified time
      def delay(milliseconds)
        sleep(milliseconds)
      end

      # Returns "2" if the screen is high-density and "1" if not
      def display_density
        raise "not implemented"
      end

      # Variable that stores the height of the computer screen
      def display_height
        raise "not implemented"
      end

      # Variable that stores the width of the computer screen
      def display_width
        raise "not implemented"
      end

      # Confirms if a Processing program is "focused"
      def focused
        raise "not implemented"
      end

      # The system variable that contains the number of frames displayed since the program started
      def frame_count
        context.frame_count
      end

      # The system variable that contains the approximate frame rate of the software as it executes
      def frame_rate
        context.frame_rate
      end

      # Specifies the number of frames to be displayed every second
      def frame_rate=
        raise "not implemented"
      end

      # Opens a sketch using the full size of the computer's display
      def full_screen
        raise "not implemented"
      end

      # System variable which stores the height of the display window
      def height
        context.height
      end

      # Hides the cursor from view
      def no_cursor
        raise "not implemented"
      end

      # Draws all geometry and fonts with jagged (aliased) edges and images with hard edges between the pixels when
      # enlarged rather than interpolating pixels
      def no_smooth
        GL.Disable(GL::MULTISAMPLE)
      end

      # It makes it possible for Processing to render using all of the pixels on high resolutions screens
      def pixel_density
        raise "not implemented"
      end

      # The actual pixel height when using high resolution display
      def pixel_height
        raise "not implemented"
      end

      # The actual pixel width when using high resolution display
      def pixel_width
        raise "not implemented"
      end

      # Used when absolutely necessary to define the parameters to size() with a variable
      def settings
        raise "not implemented"
      end

      # Defines the dimension of the display window in units of pixels
      def size(width, height)
        context.width = width
        context.height = height
      end

      # Draws all geometry with smooth (anti-aliased) edges
      def smooth
        GL.Enable(GL::MULTISAMPLE)
      end

      # System variable which stores the width of the display window
      def width
        context.width
      end
    end
  end
end
