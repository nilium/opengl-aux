#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  gl.rb
#    Basic GL functions and typedefs for snow-data.


require 'opengl-core'
require 'snow-data'
require 'opengl-aux/error'


# Extensions to the opengl-core Gl module.
module GL

  # Define snow-data typedefs for OpenGL
  Snow::CStruct.alias_type(:gl_short, :short)
  Snow::CStruct.alias_type(:gl_ushort, :unsigned_short)
  Snow::CStruct.alias_type(:gl_half, :unsigned_short)
  Snow::CStruct.alias_type(:gl_enum, :unsigned_int)
  Snow::CStruct.alias_type(:gl_uint, :unsigned_int)
  Snow::CStruct.alias_type(:gl_int, :int)
  Snow::CStruct.alias_type(:gl_fixed, :int)
  Snow::CStruct.alias_type(:gl_uint64, :uint64_t)
  Snow::CStruct.alias_type(:gl_int64, :int64_t)
  Snow::CStruct.alias_type(:gl_sizei, :int)
  Snow::CStruct.alias_type(:gl_float, :float)
  Snow::CStruct.alias_type(:gl_clampf, :float)
  Snow::CStruct.alias_type(:gl_double, :double)
  Snow::CStruct.alias_type(:gl_clampd, :double)

  GLObject = Snow::CStruct.new { gl_uint :name }

  def assert_no_gl_error(msg = nil)
    error = glGetError

    if error != GL_NO_ERROR
      raise GLStateError.new(error), msg
    end
  end

  class << self

    # @api private
    attr_accessor :__box_types__

    # @api private
    #
    # Temporarily allocates the given type, yields it to a block, and releases
    # the allocated memory. Uses alloca if available. Any additional arguments
    # to this function are forwarded to the type's allocator.
    #
    def __temp_alloc__(type, *args, &block)
      result = nil

      if type.respond_to?(:alloca)
        result = type.alloca(*args, &block)
      else
        type.new(*args) do |p|
          begin
            result = yield[p]
          ensure
            p.free!
          end
        end
      end

      result
    end

    # @api private
    #
    # Returns a boxed type for the given typename. All boxed types contain a
    # single member, 'name', which is of the boxed type. Boxed types are created
    # on demand and cached.
    #
    def __boxed_type__(typename, &block)
      box_types = (__box_types__ ||= Hash.new do |hash, type|
        hash[type] = Snow::CStruct.new { __send__(type, :name) }
      end)

      box_types[typename]
    end

    # @api private
    #
    # Wraps a previously-defined native glGen* function that returns the given
    # type of object. The glGen function returns one or more GL object names.
    # If returning a single name, the return type is Fixnum, otherwise it's an
    # array of Fixnums.
    #
    def __define_gl_gen_object_method__(name, type)
      self.module_exec(name, :"#{name}__", GL.__boxed_type__(type)) do
        |func_name, raw_name, box_type|

        define_method(func_name, -> (count) do
          return nil if count <= 0

          if count == 1
            GL.__temp_alloc__(box_type) do |p|
              send(raw_name, count, p.address)
              p.name
            end
          else
            GL.__temp_alloc__(box_type::Array, count) do |p|
              send(raw_name, count, p.address)
              Array.new(count) { |i| p[i].name }
            end
          end
        end) # define_method

      end # module_exec
    end # __define_gl_get_method__

    # @api private
    #
    # Similar to __define_gl_gen_object_method__, except for deletion. Takes
    # four possible types of objects to delete: a GLObject or an array of
    # GLObjects, a Fixnum, or an array of Fixnums. Any other types will raise
    # an error, and any type contained by an Array that is not implicitly
    # convertible to a Fixnum will also raise an error.
    #
    def __define_gl_delete_object_method__(name, type)
      self.module_exec(name, :"#{name}__") do |func_name, raw_name|

        define_method(func_name, -> (objects) do
          case objects
          when GLObject
            send(raw_name, 1, objects.address)
          when GLObject::Array
            send(raw_name, objects.length, objects.address)
          when Fixnum
            GL.__temp_alloc__(GLObject) do |p|
              p.name = objects
              send(raw_name, 1, p.address)
            end
          when Array # Assumes an array of fixnums
            GL.__temp_alloc__(GLObject::Array, objects.length) do |p|
              objects.each_with_index { |e, i| p[i].name = e }
              send(raw_name, p.length, p.address)
            end
          else
            raise ArgumentError,
            "Invalid object passed to #{name} for deletion: #{objects.inspect}"
          end
          self
        end) # define_method

      end # module_exec
    end # __define_gl_get_method__

    # @api private
    #
    # Defines a glGet* method that returns a single value of the given type.
    #
    def __define_gl_get_method__(name, type)
      self.module_exec(name, :"#{name}v__", GL.__boxed_type__(type)) do
        |func_name, raw_name, box_type|

        define_method(func_name, -> (pname) do
          GL.__temp_alloc__(box_type) do |p|
            send(raw_name, pname, p.address)
            p.name
          end
        end) # define_method

      end # module_exec
    end # __define_gl_get_method__

  end # singleton_class


  # @!method self.glGenTextures(count)
  #   Returns an array of generated texture names.
  __define_gl_gen_object_method__ :glGenTextures, :gl_uint
  # @!method self.glDeleteTextures(count, objects)
  __define_gl_delete_object_method__ :glDeleteTextures, :gl_uint

  # @!method self.glGenVertexArrays(count)
  #   Returns an array of generated vertex array object names.
  __define_gl_gen_object_method__ :glGenVertexArrays, :gl_uint
  # @!method self.glDeleteVertexArrays(count, objects)
  __define_gl_delete_object_method__ :glDeleteVertexArrays, :gl_uint

  # @!method self.glGenBuffers(count)
  #   Returns an array of generated buffer object names.
  __define_gl_gen_object_method__ :glGenBuffers, :gl_uint
  # @!method self.glDeleteBuffers(count, objects)
  __define_gl_delete_object_method__ :glDeleteBuffers, :gl_uint

  # @!method self.glGenQueries(count)
  #   Returns an array of generated query object names.
  __define_gl_gen_object_method__ :glGenQueries, :gl_uint
  # @!method self.glDeleteQueries(count, objects)
  __define_gl_delete_object_method__ :glDeleteQueries, :gl_uint

  # @!method self.glGenSamplers(count)
  #   Returns an array of generated sampler object names.
  __define_gl_gen_object_method__ :glGenSamplers, :gl_uint
  # @!method self.glDeleteSamplers(count, objects)
  __define_gl_delete_object_method__ :glDeleteSamplers, :gl_uint

  # @!method self.glGenFramebuffers(count)
  #   Returns an array of generated framebuffer object names.
  __define_gl_gen_object_method__ :glGenFramebuffers, :gl_uint
  # @!method self.glDeleteFramebuffers(count, objects)
  __define_gl_delete_object_method__ :glDeleteFramebuffers, :gl_uint

  # @!method self.glGenRenderbuffers(count)
  #   Returns an array of generated renderbuffer object names.
  __define_gl_gen_object_method__ :glGenRenderbuffers, :gl_uint
  # @!method self.glDeleteRenderbuffers(count, objects)
  __define_gl_delete_object_method__ :glDeleteRenderbuffers, :gl_uint

  # @!method self.glGenRenderbuffersProgramPipelines(count)
  #   Returns an array of generated program pipeline object names.
  __define_gl_gen_object_method__ :glGenProgramPipelines, :gl_uint
  # @!method self.glDeleteRenderbuffersProgramPipelines(count, objects)
  __define_gl_delete_object_method__ :glDeleteProgramPipelines, :gl_uint

  # @!method self.glGenRenderbuffersTrasnformFeedbacks(count)
  #   Returns an array of generated transform feedback objects
  __define_gl_gen_object_method__ :glGenTransformFeedbacks, :gl_uint
  # @!method self.glDeleteRenderbuffersTrasnformFeedbacks(count, objects)
  __define_gl_delete_object_method__ :glDeleteTransformFeedbacks, :gl_uint

  __define_gl_get_method__ :glGetInteger, :gl_int
  __define_gl_get_method__ :glGetInteger64, :gl_int64
  __define_gl_get_method__ :glGetFloat, :float
  __define_gl_get_method__ :glGetDouble, :double

  # @return [Boolean] Returns the boolean value of the given parameter name.
  def glGetBoolean(pname)
    GL.__temp_alloc__(GL.__boxed_type__(:gl_boolean)) do |p|
      p.name = 0
      glGetBooleanv(pname, p.address)
      p.name != GL::GL_FALSE
    end
  end

  # @return [String] Returns the string value of the given parameter name.
  def glGetString(name)
    glGetString__(name).to_s
  end

  # @return [String] Returns the string value of a parameter name at a given index.
  def glGetStringi(name, index)
    glGetStringi__(name, index).to_s
  end

  # Assumes sources is a
  def glShaderSource(shader, sources)
    ary_len = (source_array = sources.kind_of?(Array)) ? sources.length : 1

    lengths = GL.__boxed_type__(:gl_sizei)[ary_len]
    pointers = GL.__boxed_type__(:intptr_t)[ary_len]

    begin
      assign_block = -> (src, index) do
        lengths[index].name = src.bytesize
        pointers[index].name = Fiddle::Pointer[src].to_i
      end

      if source_array
        sources.each_with_index(&assign_block)
      else
        assign_block[sources, 0]
      end

      glShaderSource__(shader, ary_len, pointers.address, lengths.address)

    ensure
      lengths.free!
      pointers.free!
    end

    self
  end

  # Returns the version or release number. Calls glGetString.
  def gl_version
    glGetString(GL_VERSION)
  end

  # Returns the implementation vendor. Calls glGetString.
  def gl_vendor
    glGetString(GL_VENDOR)
  end

  # Returns the renderer. Calls glGetString.
  def gl_renderer
    glGetString(GL_RENDERER)
  end

  # Returns the shading language version. Calls glGetString.
  def gl_shading_language_version
    glGetString(GL_SHADING_LANGUAGE_VERSION)
  end

  # Gets an array of GL extensions. This calls glGetIntegerv and glGetStringi,
  # so be aware that you should probably cache the results.
  def gl_extensions
    Array.new(glGetInteger(GL_NUM_EXTENSIONS)) do |index|
      glGetStringi(GL_EXTENSIONS, index)
    end
  end

  def glGetShader(shader, pname)
    GL.__temp_alloc__(GL.__boxed_type__(:gl_int)) do |p|
      glGetShaderiv__(shader, pname, p.address)
      p.name
    end
  end

  def glGetShaderInfoLog(shader)
    length = glGetShader(shader, GL_INFO_LOG_LENGTH)
    return '' if length == 0
    output = ' ' * length
    glGetShaderInfoLog__(shader, output.bytesize, 0, output)
    output
  end

  def glGetShaderSource(shader)
    length = glGetShader(shader, GL_SHADER_SOURCE_LENGTH)
    return '' if length == 0
    output = ' ' * length
    glGetShaderInfoLog__(shader, output.bytesize, 0, output)
    output
  end

  def glGetProgram(program, pname)
    GL.__temp_alloc__(GL.__boxed_type__(:gl_int)) do |p|
      glGetProgramiv__(program, pname, p.address)
      p.name
    end
  end

  def glGetProgramInfoLog(program)
    length = glGetProgram(program, GL_INFO_LOG_LENGTH)
    return '' if length == 0
    output = ' ' * length
    glGetProgramInfoLog__(program, output.bytesize, 0, output)
    output
  end

  GLProgramBinary = Struct.new(:format, :data)

  def glGetProgramBinary(program)
    binary_length = glGetProgram(program, GL_PROGRAM_BINARY_LENGTH)

    return nil if binary_length <= 0

    GL.__temp_alloc__(GL.__boxed_type__(:gl_enum)) do |format_buffer; binary_buffer|
      binary_buffer = ' ' * binary_length

      glGetProgramBinary(
        program,
        binary_buffer.bytesize,
        0,
        format_buffer.address,
        binary_buffer.address
        )

      GLProgramBinary[format_buffer.name, binary_buffer]
    end
  end

  extend self

end # GL
