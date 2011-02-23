# NibJS - Examples

This folder contains typical use cases in using nib.js, one in each subfolder.
Each example is self-contained, and respects the following folder structure:

    x-example/
      build             # run to (re-)build the example
      example.js        # generated by build using nibjs command
      index.html        # to be opened in your prefered browser
      lib/
        ...             # java/coffee script source files
        
Examples are kept built in the sources, so that they can be executed immediately
in a browser. In other words, opening any x-example/index.html file in a browser
should work. Otherwise, please report the bug on github.

Please report any error on "github":https://github.com/blambeau/nib.js/issues

## 1-basic

Demonstrates a simple use case where you maintain an application as well as some
utility modules and compile them as a single self-contained .js file ready for 
inclusion in the browser (you don't even need to include nibjs itself in your
html file). NibJS is invoked as follows (see 1-basic/build):

    nibjs --libname=basic --standalone --output=basic.js lib

## Credits

Icons used in examples are from www.veryicon.com, distributed under LGPL
licence with following licence information:

TITLE:	Crystal Project Icons
AUTHOR:	Everaldo Coelho
SITE:	http://www.everaldo.com
CONTACT: everaldo@everaldo.com
LICENSE: LGPL