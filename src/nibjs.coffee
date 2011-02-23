exports.NibJS = {
  
  #
  # Package builders.
  #
  # Package builders are simply unary functions registered via NibJS.define. 
  # These functions are expected to build the package thanks to a Builder 
  # instance that they receive as first argument.
  #
  # @see define
  # @see Builder
  #
  pkgBuilders: []

  # 
  # Built packages.
  #
  # Once the package are built (lazily, at first 'require' invocation), the
  # results is put in the following array for subsequent requiring.
  #
  packages: []

  #
  # Checks if a package is known.
  #
  hasPackage: (name)->
    NibJS.pkgBuilders[name]? || NibJS.packages[name]?

  #
  # Defines a package via a name and a builder function. 
  #
  # Builder functions are expected to build the package thanks to a Builder
  # instance received as first argument. They are expected to make the first
  # require to the package index file.
  #
  # Example:
  #   NibJS.define('foo', function(nibjs){
  #     nibjs.register('bar', function(exports, require){
  #       /* content of bar.js comes here */
  #     });
  #     nibjs.register('index', function(exports, require){
  #       /* content of index.js come here */
  #     });
  #     /* Load the package at end */
  #     nibjs.require('index');
  #   });
  #
  define: (name, buildFn)->
    NibJS.pkgBuilders[name] = buildFn

  #
  # Returns a package, building it if required (equivalent to Node's _require_).
  #
  # Example:
  #   Foo = NibJS.require('foo')
  #   Foo.Bar = ...
  #
  require: (name)->
    NibJS.packages[name] ?= NibJS._build_one(name)
  
  #
  # Internal implementation of require, when invoked the first time on
  # a given library.
  #  
  _build_one: (name)->
    if NibJS.pkgBuilders[name]
      builder = new Builder
      NibJS.pkgBuilders[name](builder)
    else
      throw new Exception("NibJS error: no module '#{name}' has been previously registered.")

}

class Exception extends Error
  constructor: (@message)->

#
# Intra-package builder, passed as first argument of NibJS.define
#
# This builder helps registrering functions for building individual
# files, as well as requiring them.
#
class Builder

  #
  # Builds a builder instance
  #
  constructor: ()->
    @builders = []
    @built = []

  #
  # Register a builder function for _file_.
  #
  # The builder function will be called when the file will be required later. 
  # It takes two parameters as arguments, exports and require. The first one 
  # allows the file to exports artifacts while the second one mimics the 
  # Node's require function.
  #
  register: (file, builder)=>
    @builders[file] = builder

  #
  # Mimics Node's require in the context of this building.
  #
  # This function returns the result of requiring _file_, building it with 
  # the function previously registered (if not previously done).
  #
  require: (file)=>
    @built[file] ?= this.build_file(file)

  #
  # Private functions that ensures the building of a file.
  #
  build_file: (file)=>
    if @builders[file]?
      file_exp = {}
      @builders[file](file_exp, this.require)
      file_exp
    else
     throw new Exception("NibJS error: no such file #{file}")