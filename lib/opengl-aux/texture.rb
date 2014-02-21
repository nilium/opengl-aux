#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  texture.rb
#    GL texture object wrapper.


require 'opengl-aux/gl'
require 'opengl-aux/error'


class GL::Texture

  class << self

    attr_accessor :__texture_target_getters__

    def current_unit
      GL.glGetInteger(GL::GL_ACTIVE_TEXTURE)
    end

    def current_binding(target)
      GL.glGetInteger(__texture_target_getters__[target])
    end

    def preserve_unit
      unit = current_unit
      begin
        yield
      ensure
        GL.glActiveTexture(unit)
      end
    end

    # Implied preserve_unit
    def preserve_binding(target)
      preserve_unit do
        binding = current_binding(target)
        begin
          yield
        ensure
          GL.glBindTexture(target, binding)
        end
      end
    end

  end # singleton_class


  self.__texture_target_getters__ = {
    GL::GL_TEXTURE_1D                   => GL::GL_TEXTURE_BINDING_1D,
    GL::GL_TEXTURE_2D                   => GL::GL_TEXTURE_BINDING_2D,
    GL::GL_TEXTURE_3D                   => GL::GL_TEXTURE_BINDING_3D,
    GL::GL_TEXTURE_1D_ARRAY             => GL::GL_TEXTURE_BINDING_1D_ARRAY,
    GL::GL_TEXTURE_2D_ARRAY             => GL::GL_TEXTURE_BINDING_2D_ARRAY,
    GL::GL_TEXTURE_RECTANGLE            => GL::GL_TEXTURE_BINDING_RECTANGLE,
    GL::GL_TEXTURE_CUBE_MAP             => GL::GL_TEXTURE_BINDING_CUBE_MAP,
    GL::GL_TEXTURE_CUBE_MAP_ARRAY       => GL::GL_TEXTURE_BINDING_CUBE_MAP_ARRAY,
    GL::GL_TEXTURE_BUFFER               => GL::GL_TEXTURE_BINDING_BUFFER,
    GL::GL_TEXTURE_2D_MULTISAMPLE       => GL::GL_TEXTURE_BINDING_2D_MULTISAMPLE,
    GL::GL_TEXTURE_2D_MULTISAMPLE_ARRAY => GL::GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY,
  }

  self.__texture_target_getters__.default_proc = -> (hash, key) do
    raise ArgumentError, "No queryable texture binding target for #{key}"
  end


  attr_reader   :name
  attr_accessor :target

  def initialize(target = nil, name = nil)
    @name = name || 0
    @target = target
    yield self if block_given?
  end

  def is_texture?
    GL::glIsTexture(@name) != GL::GL_FALSE
  end

  def delete
    if @name != 0
      GL.glDeleteTextures(@name)
      @name = 0
    end
  end

  def bind(target = nil)
    # You may think this is insane, but I assure you, it isn't.
    target ||= (@target || GL_TEXTURE_2D)
    @target ||= target
    raise ArgumentError, "No target given and no previous target" unless target

    if block_given?
      self.class.preserve_binding(target) do
        bind(target)
        yield self
      end
    else
      if @name == 0
        @name ||= GL.glGenTextures(1)
        if @name == 0
          raise GL::GLCreateError, "Unable to allocate texture object"
        end
      end

      GL.glBindTexture(target, @name)
      self
    end
  end

end # GL::Texture
