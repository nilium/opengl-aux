#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  program.rb
#    GL program object wrapper.


require 'opengl-aux/gl'


# Declare it just for type checking
class GL::Shader ; end

class GL::Program


  class << self

    def current_program
      GL::glGetInteger(GL::GL_CURRENT_PROGRAM)
    end

    def preserve_binding
      raise ArgumentError, "No block given" unless block_given?
      current = current_program
      begin
        yield
      ensure
        GL.glUseProgram(current)
      end
    end

  end # singleton_class


  attr_reader :name

  def initialize(name = nil)
    if name
      @name = name
    else
      @name = GL.glCreateProgram()
      raise GL::GLCreateError, "Unable to allocate shader" if @name == 0
    end

    @uniform_locations = {}

    yield self if block_given?
  end

  def delete
    if @name != 0
      GL.glDeleteProgram(@name)
      @name = 0
    end
    self
  end

  def is_program?
    GL::glIsProgram(@name) != GL::GL_FALSE
  end

  def load_binary(binary_format, binary_string)
    GL.glProgramBinary(@name, binary_format, binary_string, binary_string.bytesize)
    __reload_uniforms__ if (link_successful = linked?)
    link_successful
  end

  def binary
    GL.glGetProgramBinary(@name)
  end

  def __reload_uniforms__
    locs = @uniform_locations
    locs.each_key do |key|
      locs[key] = GL.glGetUniformLocation(@name, key.to_s)
    end
  end

  def link
    GL.glLinkProgram(@name)
    @link_status = nil
    __reload_uniforms__ if (link_successful = linked?)
    link_successful
  end

  def linked?
    GL.glGetProgram(@name, GL::GL_LINK_STATUS) != GL::GL_FALSE
  end

  def valid?
    GL.glValidateProgram(@name)
    GL.glGetProgram(@name, GL::GL_VALIDATE_STATUS) != GL::GL_FALSE
  end

  def info_log
    GL.glGetProgramInfoLog(@name)
  end

  def use
    if block_given?
      preserve_binding do
        use
        yield self
      end
    else
      GL.glUseProgram(@name)
      self
    end
  end

  def attach_shader(shader)
    case shader
    when ::GL::Shader then GL.glAttachShader(@name, shader.name)
    else GL.glAttachShader(@name, shader)
    end
    self
  end

  def detach_shader(shader)
    case shader
    when ::GL::Shader then GL.glDetachShader(@name, shader.name)
    else GL.glDetachShader(@name, shader)
    end
    self
  end

  def hint_uniform(name)
    name = name.to_sym
    @uniform_locations[name] ||= nil
    self
  end

  def uniform_location(name)
    uniform_sym = name.to_sym
    locations = @uniform_locations
    locations[uniform_sym] ||= GL.glGetUniformLocation(@name, name.to_s)
  end
  alias_method :[], :uniform_location

  def clear_uniform_location_cache
    @uniform_locations.clear
  end

  def subroutine_uniform_location(shader_kind, uniform_name)
    GL.glGetSubroutineUniformLocation(@name, shader_kind, uniform_name)
  end

  def bind_attrib_location(attrib_index, attrib_name)
    GL.glBindAttribLocation(@name, attrib_index, attrib_name.to_s)
    self
  end

  def bind_frag_data_location(color_number, frag_data_name)
    GL.glBindFragDataLocation(@name, color_number, frag_data_name.to_s)
    self
  end

end
