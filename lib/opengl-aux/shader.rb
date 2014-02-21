#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  shader.rb
#    GL shader object wrapper.


require 'opengl-aux/gl'


class GL::Shader

  attr_reader :name
  attr_reader :kind

  def initialize(kind, name = nil)
    if name
      @name = name
    else
      @name = GL.glCreateShader(kind)
      raise GL::GLCreateError, "Unable to allocate shader" if @name == 0
    end

    @kind = kind
    yield self if block_given?
  end

  def delete
    if @name != 0
      GL.glDeleteShader(@name)
      @name = 0
    end
    self
  end

  def is_shader?
    GL::glIsShader(@name) != GL::GL_FALSE
  end

  def source=(sources)
    GL.glShaderSource(@name, sources)
    sources
  end

  def source
    GL.glGetShaderSource(@name)
  end

  def compile
    GL.glCompileShader(@name)
    compiled?
  end

  def compiled?
    GL.glGetShader(@name, GL::GL_COMPILE_STATUS) != GL::GL_FALSE
  end

  def info_log
    GL.glGetShaderInfoLog(@name)
  end

end
