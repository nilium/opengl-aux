#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  buffer.rb
#    GL buffer object wrapper.


require 'opengl-aux/gl'
require 'opengl-aux/error'


class GL::Buffer

  class << self

    attr_accessor :__buffer_target_getters__

    def current_binding(target)
      GL.glGetInteger(__buffer_target_getters__[target])
    end

    def preserve_binding(target)
      raise ArgumentError, "No block given" unless block_given?
      current = current_binding(target)
      begin
        yield
      ensure
        GL.glBindBuffer(target, current)
      end
    end

  end # singleton_class


  self.__buffer_target_getters__ = {
    GL::GL_ARRAY_BUFFER              => GL::GL_ARRAY_BUFFER_BINDING,
    GL::GL_ATOMIC_COUNTER_BUFFER     => GL::GL_ATOMIC_COUNTER_BUFFER_BINDING,
    GL::GL_DISPATCH_INDIRECT_BUFFER  => GL::GL_DISPATCH_INDIRECT_BUFFER_BINDING,
    GL::GL_DRAW_INDIRECT_BUFFER      => GL::GL_DRAW_INDIRECT_BUFFER_BINDING,
    GL::GL_ELEMENT_ARRAY_BUFFER      => GL::GL_ELEMENT_ARRAY_BUFFER_BINDING,
    GL::GL_PIXEL_PACK_BUFFER         => GL::GL_PIXEL_PACK_BUFFER_BINDING,
    GL::GL_PIXEL_UNPACK_BUFFER       => GL::GL_PIXEL_UNPACK_BUFFER_BINDING,
    GL::GL_QUERY_BUFFER              => GL::GL_QUERY_BUFFER_BINDING,
    GL::GL_SHADER_STORAGE_BUFFER     => GL::GL_SHADER_STORAGE_BUFFER_BINDING,
    GL::GL_SHADER_STORAGE_BUFFER     => GL::GL_SHADER_STORAGE_BUFFER_BINDING,
    GL::GL_TEXTURE_BUFFER            => GL::GL_TEXTURE_BUFFER_BINDING,
    GL::GL_TRANSFORM_FEEDBACK_BUFFER => GL::GL_TRANSFORM_FEEDBACK_BUFFER_BINDING,
    GL::GL_UNIFORM_BUFFER            => GL::GL_UNIFORM_BUFFER_BINDING,
  }

  __buffer_target_getters__.default_proc = -> (hash, key) do
    raise ArgumentError, "No queryable buffer binding target for #{key}"
  end


  attr_reader :name
  attr_accessor :target

  def initialize(target = nil, name = nil)
    @name = (name != 0 && name) || 0
    @target = target
    yield self if block_given?
  end

  def is_buffer?
    GL::glIsBuffer(@name) != GL::GL_FALSE
  end

  def delete
    if @name != 0
      GL.glDeleteBuffers(@name)
      @name = 0
    end
    self
  end

  def bind(target = nil)
    target ||= (@target || GL::GL_ARRAY_BUFFER)
    @target ||= target
    raise ArgumentError, "No target given and no previous target" unless target

    if block_given?
      self.class.preserve_binding(target) do
        yield self
      end
    else
      if @name == 0
        @name = GL.glGenBuffers(1)
        if @name == 0
          raise GL::GLCreateError, "Unable to allocate buffer object"
        end
      end

      GL.glBindBuffer(target, @name)
      self
    end
  end

end # GL::Buffer
