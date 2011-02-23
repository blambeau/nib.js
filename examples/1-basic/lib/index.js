/*
 * This is the main package file, re-exporting the Foo application 
 * as well as StringUtils.
 *
 * It also exports an App that can be started in the browser to check
 * that everything is ok!
 */
exports.StringUtils = require('./StringUtils').StringUtils;
exports.Foo = require('./Foo').Foo;

/*
 * Main application exported in the browser.
 *
 * Usage:
 * 
 *   <script>
 *     App = NibJS.require('the name you provided at nibjs time').App;
 *     App.runTests();
 *   </script>
 * 
 */
exports.App = {
  
  runTests: function(){
    var hello = exports.Foo.sayHello("world");
    $("body").append("<h1>" + hello + "</h1>");
    return true;
  }
  
};