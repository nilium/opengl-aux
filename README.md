opengl-aux
==========

opengl-aux is a collection of auxiliary OpenGL functions and types for working with the opengl-core gem. It includes simple wrappers around existing OpenGL types such as buffer objects, vertex array objects, and program objects as well as simplified functions for retrieving the extensions list, glGet without the use of pointers, and other niceties.


Contributing
------------

Want to contribute to the development of opengl-aux? Need something wrapped that isn't already wrapped? You can contribute either by creating issues on or submitting pull requests for changes on the [opengl-aux GitHub page][GitHub]. Welcome changes include anything from usability questions to bug reports and fixes to additional or improved GL object wrappers.

[GitHub]: https://github.com/nilium/opengl-aux

Specific areas where opengl-aux is lacking include documentation, examples, and GL object wrappers. As of this writing, there are only programs, shaders, textures, buffers, and vertex array objects -- they comprise the majority of what you'll do, but a somewhat Ruby-like interface for everything would eventually be welcome.

The only major requirement for code contributions is that you agree to license your contribution under the same license as opengl-aux (shown below). Aside from that, if you have any questions, feel free to create an issue.


Contributors
------------

This is a list of everyone who has contributed in any meaningful way to opengl-aux's development thus far:

- [Justin Scott](https://github.com/JScott)
- [Noel Cower](https://github.com/nilium)


License
-------

The opengl-aux source code is licensed under a simplified two-clause BSD license:

> Copyright (c) 2013 - 2014, opengl-aux project contributors.  
> All rights reserved.
> 
> Redistribution and use in source and binary forms, with or without
> modification, are permitted provided that the following conditions are met:
> 
> 1. Redistributions of source code must retain the above copyright notice, this
>    list of conditions and the following disclaimer.
>
> 2. Redistributions in binary form must reproduce the above copyright notice,
>    this list of conditions and the following disclaimer in the documentation
>    and/or other materials provided with the distribution.
> 
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
> ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
> ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


