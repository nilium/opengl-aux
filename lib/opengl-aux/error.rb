#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  error.rb
#    Error types used by opengl-aux.


module GL

  # Generic error that should probably be subclassed for more specific errors.
  # Can be used as a catch-all for GL-specific errors.
  class GLError < StandardError ; end

  # An error that should be raised if a call to a glGen* or glCreate* function
  # fails.
  class GLCreateError < GLError ; end

  # State error raised for errors returned by glGetError.
  class GLStateError < GLError
    attr_reader :code

    def self.exception(msg = nil, code = GL::GL_NO_ERROR)
      new(code, msg)
    end

    def initialize(code, msg = nil)
      @code = code
      super(msg)
    end

    def exception(msg = nil)
      if msg
        self.class.exception(msg, code)
      else
        self
      end
    end

    def to_s
      code_str =
        case self.code
        when GL::GL_NO_ERROR                      then 'NO_ERROR'
        when GL::GL_INVALID_ENUM                  then 'INVALID_ENUM'
        when GL::GL_INVALID_VALUE                 then 'INVALID_VALUE'
        when GL::GL_INVALID_OPERATION             then 'INVALID_OPERATION'
        when GL::GL_INVALID_FRAMEBUFFER_OPERATION then 'INVALID_FRAMEBUFFER_OPERATION'
        when GL::GL_OUT_OF_MEMORY                 then 'OUT_OF_MEMORY'
        when GL::GL_STACK_UNDERFLOW               then 'STACK_UNDERFLOW'
        when GL::GL_STACK_OVERFLOW                then 'STACK_OVERFLOW'
        end
      "#{code_str}: #{super}"
    end
  end # GLStateError

end # GL
