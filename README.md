# NibJS

nib.js - Package and embed node.js or coffeescript libraries in the browser

nib.js is a NibJS javascript library allowing to maintain javascript/coffeescript projects 
ala 'node.js' (modules, exports, require) while also targetting a web browser as execution 
platform. It contains a simple packager command (nibjs) that will convert your sources to a 
single and minified .js file to be embedded in the browser. Node.js's exports and require 
are correctly bounded.

## Getting started

    gem install nibjs
    nibjs --help 

## How to use it

Let assume that your project has the structure below. 

    mylib/
      dist/
      src/
        foo.[js,coffee]          # exports.Foo = ...
        bar.[js,coffee]          # require('./foo')
        index.[js,coffee]        # exports.X = ...
      spec/
        foo_spec.[js,coffee]
        bar_spec.[js,coffee]
      package.json

EXAMPLE 1 (embedded javascript):

  In a shell:

    # if the sources are .js
    nibjs --libname=mylib --output=mylib.js src

    # if the sources are .coffee
    nibjs --coffee --libname=mylib --output=mylib.js src

  In the browser:

    <script src="js/nibjs.js" type="text/javascript">
    <script src="js/mylib.js" type="text/javascript">
    <script>
      var mylib = NibJS.require('mylib')
    </script>

EXAMPLE 2 (embedded coffeescript):

  In a shell:

    nibjs --coffee --no-coffee-compile --libname=mylib --output=mylib.coffee src

  In the browser:

    <script src="js/nibjs.js"     type="text/javascript">
    <script src="js/mylib.coffee" type="text/coffeescript">
    <script>
      /* But be warned of coffeescript's issue 1054
         https://github.com/jashkenas/coffee-script/issues/#issue/1054 */
      var mylib = NibJS.require('mylib')
    </script>
