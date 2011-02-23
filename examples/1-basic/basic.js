/**
 * nib.js - [Java/Coffee]script application packager from node.js conventions
 * 
 * Copyright 2011, Bernard Lambeau
 * Released under the MIT License
 * http://github.com/blambeau/nib.js
 */
(function(exports){
  var Builder, Exception;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  exports.NibJS = {
    pkgBuilders: [],
    packages: [],
    define: function(name, buildFn) {
      return NibJS.pkgBuilders[name] = buildFn;
    },
    require: function(name) {
      var _base, _ref;
      return (_ref = (_base = NibJS.packages)[name]) != null ? _ref : _base[name] = NibJS._build_one(name);
    },
    _build_one: function(name) {
      var builder;
      if (NibJS.pkgBuilders[name]) {
        builder = new Builder;
        return NibJS.pkgBuilders[name](builder);
      } else {
        throw new Exception("NibJS error: no module '" + name + "' has been previously registered.");
      }
    }
  };
  Exception = (function() {
    __extends(Exception, Error);
    function Exception(message) {
      this.message = message;
    }
    return Exception;
  })();
  Builder = (function() {
    function Builder() {
      this.build_file = __bind(this.build_file, this);;
      this.require = __bind(this.require, this);;
      this.register = __bind(this.register, this);;    this.builders = [];
      this.built = [];
    }
    Builder.prototype.register = function(file, builder) {
      return this.builders[file] = builder;
    };
    Builder.prototype.require = function(file) {
      var _base, _ref;
      return (_ref = (_base = this.built)[file]) != null ? _ref : _base[file] = this.build_file(file);
    };
    Builder.prototype.build_file = function(file) {
      var exports;
      if (this.builders[file] != null) {
        exports = {};
        this.builders[file](exports, this.require);
        return exports;
      } else {
        throw new Exception("NibJS error: no such file " + file);
      }
    };
    return Builder;
  })();
}).call(this, this);

NibJS.define('basic', function(nibjs) {
  nibjs.register('./Foo', function(exports, require) {
    /* We include string utilities under Utils */
    Utils = require('./StringUtils').StringUtils;
    
    /* This is the main application, which is able to say hello to the 
     * world. */
    exports.Foo = {
      
      sayHello: function(who){
        return "Hello " + Utils.upcase(who);
      }
      
    };
  });
  nibjs.register('./index', function(exports, require) {
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
  });
  nibjs.register('./StringUtils', function(exports, require) {
    /**
     * This module exports string utilities under StringUtils.
     *
     * Example:
     *
     *   SU = require('./StringUtils').StringUtils;
     *   SU.upcase('Hello World!');
     *
     */
    exports.StringUtils = {
      
      upcase: function(what){
        return what.toUpperCase();
      }
      
    };
  });
  return nibjs.require('./index');
});
