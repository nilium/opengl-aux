#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  vertex_array.rb
#    GL vertex array object wrapper.


require 'opengl-aux/gl'
require 'opengl-aux/error'


class GL::VertexArray

  class << self

    def current_binding
      GL.glGetInteger(GL::GL_VERTEX_ARRAY_BINDING)
    end

    def preserve_binding
      raise ArgumentError, "No block given" unless block_given?
      binding = current_binding
      begin
        yield
      ensure
        GL.glBindVertexArray(binding)
      end
    end

  end # singleton_class


  attr_reader :name

  def initialize(name = nil)
    @name = name || 0
    yield self if block_given?
  end

  def delete
    if @name != 0
      GL.glDeleteVertexArrays(@name)
      @name = 0
    end
    self
  end

  def is_vertex_array?
    GL::glIsVertexArray(@name) != GL::GL_FALSE
  end

  def bind
    if block_given?
      self.class.preserve_binding do
        bind
        yield self
      end
    else
      if @name == 0
        @name = GL.glGenVertexArrays(1)
        if @name == 0
          raise GL::GLCreateError, "Unable to allocate vertex array object"
        end
      end

      GL.glBindVertexArray(@name)
      self
    end
  end

end # GL::VertexArray
