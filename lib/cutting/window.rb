# frozen_string_literal: true

require "glfw"
require "oily_png"
require "opengl"
require_relative "context"
require_relative "api"

module Cutting
  # Creates a Cutting window that will render whatever is described on its draw method
  class Window < GLFW::Window
    include Api
    FPS_SMOOTHING = 0.2

    def initialize(title)
      @context = Context.new

      GLFW.init
      init_hints

      super(context.width, context.height, title, vsync: true)

      # self.icon = Image.new('../glfw-icon.png')
      init_config
      init_callbacks
    end

    def main
      setup

      show
      until closing?
        GL.MatrixMode(GL::PROJECTION)
        GL.LoadIdentity()
        GL.Ortho(0.0, context.width, context.height, 0.0, 1.0, -1.0)
        GL.MatrixMode(GL::MODELVIEW)

        draw

        swap_buffers
        GLFW.poll_events
        context.frame_count += 1
        current_time = Time.now
        context.frame_rate = update_frame_rate(current_time)
        context.frame_last_time = current_time
      end
    ensure
      teardown
      GLFW.terminate
    end

    protected

    attr_reader :context

    def setup
      # Override this to set up
    end

    def draw
      # Override this to draw
    end

    private

    def update_frame_rate(current_time)
      (FPS_SMOOTHING / ((current_time - context.frame_last_time))) + ((1 - FPS_SMOOTHING) * context.frame_rate)
    end

    def init_hints
      GLFW::Window.default_hints
      GLFW::Window.hint(GLFW::HINT_DECORATED, true)
      GLFW::Window.hint(GLFW::HINT_CLIENT_API, GLFW::API_OPENGL)
      GLFW::Window.hint(GLFW::HINT_DOUBLEBUFFER, true)
      GLFW::Window.hint(GLFW::HINT_RESIZABLE, true)
      GLFW::Window.hint(GLFW::HINT_VISIBLE, false)
      GLFW::Window.hint(GLFW::HINT_SAMPLES, 16)
      # GLFW::Window.hint(GLFW::HINT_CONTEXT_VERSION_MAJOR, 3)
      # GLFW::Window.hint(GLFW::HINT_CONTEXT_VERSION_MINOR, 3)
      # GLFW::Window.hint(GLFW::HINT_OPENGL_PROFILE, GLFW::PROFILE_OPENGL_CORE)
      # GLFW::Window.hint(GLFW::HINT_OPENGL_FORWARD_COMPAT, true)
    end

    def init_config
      make_current
      GL.load_lib

      GL.Enable(GL::MULTISAMPLE)

      GL.Enable(GL::POINT_SMOOTH)
      GL.Hint(GL::POINT_SMOOTH_HINT, GL::NICEST)
      GL.Enable(GL::LINE_SMOOTH)
      GL.Hint(GL::LINE_SMOOTH_HINT, GL::NICEST)
      GL.Enable(GL::POLYGON_SMOOTH)
      GL.Hint(GL::POLYGON_SMOOTH, GL::NICEST)

      GL.Enable(GL::BLEND)
      GL.BlendFunc(GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA)

      GL.Viewport(0, 0, context.width, context.height)
      GL.ClearColor(*context.background)

      GL.Clear(GL::COLOR_BUFFER_BIT)
      swap_buffers
      GL.Clear(GL::COLOR_BUFFER_BIT)
    end

    def init_callbacks
      on_framebuffer_resize do |width, height|
        context.width = width
        contex.height = height
        GL.Ortho(0.0, context.width, context.height, 0.0, 1.0, -1.0)
        GL.Viewport(0, height, width, 0)
      end
    end

    def teardown
      return if context.saved_frames.empty?

      frame_amount = context.saved_frames.size
      puts "Rendering #{frame_amount} frames..."
      start_time = Time.now

      (0...frame_amount).each do
        filename, width, height, pixels = context.saved_frames.shift

        columns = width * 3
        size = height * columns
        last_row = size - columns
        flipped = String.new(capacity: size)
        (0...size).step(columns).reverse_each do |start|
          flipped[last_row - start, columns] = pixels[start, columns]
        end

        image = ::ChunkyPNG::Image.from_rgb_stream(width, height, flipped)
        image.save(filename)
      end

      end_time = Time.now
      puts "Rendering finished in #{end_time - start_time} (#{(end_time - start_time) / frame_amount} fps)"
    end
  end
end
