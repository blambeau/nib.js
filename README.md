# NibJS

nib.js - Package CommonJS (Node.js) java/coffeescript libraries for the browser

nib.js is a library allowing to maintain javascript projects ala 'node.js' (CommonJS conventions
about modules, exports, require) while also targetting the web browser as execution platform. It
contains a simple packager command (nibjs) that will convert your sources to a single and
minified .js file to be embedded in the browser. Node.js's exports and require are correctly
resolved.

## Getting started

    gem install nibjs
    nibjs --help 

## How to use it

Let assume that your project has the structure below. 

    mylib/
      dist/
      lib/
        Foo.[js,coffee]          # exports.Foo = ...
        Bar.[js,coffee]          # require('./Foo')
        index.[js,coffee]        # exports.X = ...
      spec/
        foo_spec.[js,coffee]
        bar_spec.[js,coffee]
      package.json

### EXAMPLE 1 (embedded javascript):

  In a shell:

    # if the sources are .js
    nibjs --libname=mylib --output=dist/mylib.js lib

    # if the sources are .coffee
    nibjs --coffee --libname=mylib --output=dist/mylib.js lib

  In the browser:

    <script src="js/nibjs.js" type="text/javascript">
    <script src="js/mylib.js" type="text/javascript">
    <script>
      // mylib contains what index.[js,coffee] exports
      var mylib = NibJS.require('mylib')
    </script>

### EXAMPLE 2 (embedded coffeescript):

  In a shell:

    nibjs --coffee --no-coffee-compile --libname=mylib --output=dist/mylib.coffee lib

  In the browser:

    <script src="js/coffee-script.js" type="text/javascript">
    <script src="js/nibjs.js" type="text/javascript">
    <script src="js/mylib.coffee" type="text/coffeescript">
    <script>
      /* But be warned of coffeescript's issue 1054
         https://github.com/jashkenas/coffee-script/issues/#issue/1054 */
      var mylib = NibJS.require('mylib')
    </script>

### EXAMPLE 3 (get rid of nibjs.js):

  In a shell:

    nibjs --standalone --libname=mylib --output=dist/mylib.js lib

  In the browser:

    <script src="js/mylib.js" type="text/coffeescript">
    <script>
      // NibJS is itself included in mylib.js
      var mylib = NibJS.require('mylib')
    </script>

### See also

This project is related to CommonJS Module specification. In a sense, it is an offline 
"compiler" implementation of the version 1.0 of that specification (not even complete).
I'll strongly consider any patch that would lead to respecting such specification more
completely!

* http://wiki.commonjs.org/wiki/Modules/1.0
* http://wiki.commonjs.org/wiki/Modules/CompiledModules

Other projects that implement the CommonJS module specification in a similar way:

* https://github.com/rsms/browser-require
* https://github.com/weepy/brequire
* https://github.com/afriggeri/ristretto