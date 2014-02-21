#  This file is part of the opengl-aux project.
#  <https://github.com/nilium/opengl-aux>
#
#  -----------------------------------------------------------------------------
#
#  opengl-aux.gemspec
#    Gem specification for opengl-aux.


require File.expand_path('../lib/opengl-aux/version.rb', __FILE__)


Gem::Specification.new do |s|
  s.name        = 'opengl-aux'
  s.version     = GL::OPENGL_AUX_VERSION
  s.summary     = 'Auxiliary types and functions for OpenGL use.'
  s.description = 'A collection auxiliary of functions and types to simplify using the opengl-core gem.'
  s.authors     = [ 'Noel Raymond Cower' ]
  s.email       = 'ncower@gmail.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.homepage    = 'https://github.com/nilium/opengl-aux'
  s.license     = 'Simplified BSD'
  s.required_ruby_version = '~> 2.0'

  s.add_runtime_dependency 'opengl-core', '~> 2.0'
  s.add_runtime_dependency 'snow-data', '~> 1.3', '>= 1.3.1'
end
