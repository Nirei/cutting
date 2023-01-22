# frozen_string_literal: true

require "glfw"
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
        GL.Ortho(0.0, context.width, 0, context.height, 1.0, -1.0)
        GL.MatrixMode(GL::MODELVIEW)

        draw

        swap_buffers
        GLFW.poll_events
        context.frame_count += 1
        current_time = Time.now
        context.frame_rate = update_frame_rate(current_time)
        context.frame_last_time = current_time
      end
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
        @width = width
        @height = height
        GL.Viewport(0, 0, width, height)
      end
    end
  end
end
