# This file is part of opengl-aux.
# Copyright (c) 2014 Noel Raymond Cower. All rights reserved.
# See COPYING for license details.

Gem::Specification.new { |s|
  s.name        = 'opengl-aux'
  s.version     = '1.0.0'
  s.summary     = 'Auxiliary types and functions for OpenGL use.'
  s.description = 'A collection auxiliary of functions and types to simplify using the opengl-core gem.'
  s.authors     = [ 'Noel Raymond Cower' ]
  s.email       = 'ncower@gmail.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.homepage    = 'https://github.com/nilium/opengl-aux'
  s.license     = 'Simplified BSD'
  s.required_ruby_version = '~> 2'

  s.add_runtime_dependency 'opengl-core', '~> 2.0'
  s.add_runtime_dependency 'snow-data', '~> 1.3', '>= 1.3.1'
}
