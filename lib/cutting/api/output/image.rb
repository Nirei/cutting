# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Output
      # Used to output image files
      module Image
        # Saves an image from the display window
        def save(filename)
          width = context.width
          height = context.height
          size = width * height
          bufsize = size * Fiddle::SIZEOF_UINTPTR_T
          free = Fiddle::Function.new(Fiddle::RUBY_FREE, [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOID)
          Fiddle::Pointer.malloc(bufsize, free) do |pointer|
            GL.ReadnPixels(0, 0, width, height, GL::RGB, GL::UNSIGNED_BYTE, bufsize, pointer)
            context.saved_frames << [filename, width, height, pointer.to_str]
          end
        end

        # Saves a numbered sequence of images, one image each time the function is run
        def save_frame(file_pattern = "screen-####.png")
          padding = file_pattern.count("#")
          raise ArgumentError, "save_frame needs at least one # in the file name" if padding.zero?

          frame_count = context.frame_count.to_s.rjust(padding, "0")
          filename = file_pattern.gsub(/([\w\-.]+)(?:\#+)([\w\-.]+)/, "\\1#{frame_count}\\2")
          save(filename)
        end
      end
    end
  end
end
