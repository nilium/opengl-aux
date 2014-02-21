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

    def initialize(code, msg = nil)
      @code = code
      super(msg)
    end

    def exception(msg = nil)
      if msg
        self.class.new(code, msg)
      else
        self
      end
    end
  end # GLStateError

end # GL
