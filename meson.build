project('hideki-open-it', 'cpp',
  version : '0.1',
  default_options : ['warning_level=3', 'cpp_std=c++14'])

cmake = import('cmake')
raylib = cmake.subproject('raylib')
raylib_lib = raylib.dependency('raylib')

executable(
  'hideki-open-it',
  'src/main.cpp',
  dependencies : [raylib_lib],
  install : true
)
