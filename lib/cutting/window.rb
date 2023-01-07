# frozen_string_literal: true

require "glfw"
require "opengl"

module Cutting
  class Window < GLFW::Window
    def initialize(width, height, title)
      @width = width
      @height = height

      GLFW.init
      init_hints

      super(width, height, title, vsync: true)

      # self.icon = Image.new('../glfw-icon.png')
      init_config(width, height)
      init_callbacks
    end

    def main
      setup

      show
      until closing?
        draw

        swap_buffers
        GLFW.poll_events
      end
      GLFW.terminate
    end

    protected

    attr_reader :width
    attr_reader :height

    def setup
    end

    def draw
      GL.Clear(GL::COLOR_BUFFER_BIT)
      GL.MatrixMode(GL::PROJECTION)
      GL.LoadIdentity()
      ratio = width.to_f / height.to_f
      GL.Ortho(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
      GL.MatrixMode(GL::MODELVIEW)

      GL.LoadIdentity()
      GL.Rotatef(GLFW.time * 50.0, 0.0, 0.0, 1.0)

      GL.Begin(GL::TRIANGLES)
      GL.Color3f(1.0, 0.0, 0.0)
      GL.Vertex3f(-0.6, -0.4, 0.0)
      GL.Color3f(0.0, 1.0, 0.0)
      GL.Vertex3f(0.6, -0.4, 0.0)
      GL.Color3f(0.0, 0.0, 1.0)
      GL.Vertex3f(0.0, 0.6, 0.0)
      GL.End()
    end


    private

    def init_hints
      GLFW::Window.default_hints
      GLFW::Window.hint(GLFW::HINT_DECORATED, true)
      GLFW::Window.hint(GLFW::HINT_CLIENT_API, GLFW::API_OPENGL)
      GLFW::Window.hint(GLFW::HINT_DOUBLEBUFFER, true)
      GLFW::Window.hint(GLFW::HINT_RESIZABLE, true)
      GLFW::Window.hint(GLFW::HINT_VISIBLE, false)
      # GLFW::Window.hint(GLFW::HINT_CONTEXT_VERSION_MAJOR, 3)
      # GLFW::Window.hint(GLFW::HINT_CONTEXT_VERSION_MINOR, 3)
      # GLFW::Window.hint(GLFW::HINT_OPENGL_PROFILE, GLFW::PROFILE_OPENGL_CORE)
      # GLFW::Window.hint(GLFW::HINT_OPENGL_FORWARD_COMPAT, true)
    end

    def init_config(width, height)
      make_current
      GL.load_lib

      GL.Viewport(0, 0, width, height)
      GL.ClearColor(1.0, 1.0, 1.0, 1.0)
      
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
