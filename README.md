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
        foo.[js,coffee]            # exports.Foo = ...
        bar.[js,coffee]            # require('./foo')
        index.[js,coffee]          # exports.X = ...
      spec/
        foo_spec.[js,coffee]
        bar_spec.[js,coffee]
      package.json

To package all source files while respecting exports and require semantics, you just have to
execute the following command:
    
    nibjs [--coffee] --libname=mylib --output=dist/mylib-1.0.0.js src
    
In the browser, you'll have to include nibjs.js and mylib.js and then requiring your lib to 
NibJS:

    <script src="js/nibjs-1.0.0.min.js" type="text/javascript">
    <script src="js/mylib-1.0.0.min.js" type="text/javascript">
    <script>
      <!-- assuming jquery as well -->
      $(document).ready(function(){
        // Require the name you passed as --libname at nibjs packaging time
        // mylib contains your index's exports (mylib.X is defined, for example)
        var mylib = NibJS.require('mylib')
      });
    </script>

## Links

http://github.com/blambeau/nib.js

