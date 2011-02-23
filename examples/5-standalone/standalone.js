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
    hasPackage: function(name) {
      return (NibJS.pkgBuilders[name] != null) || (NibJS.packages[name] != null);
    },
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
      var file_exp;
      if (this.builders[file] != null) {
        file_exp = {};
        this.builders[file](file_exp, this.require);
        return file_exp;
      } else {
        throw new Exception("NibJS error: no such file " + file);
      }
    };
    return Builder;
  })();
}).call(this, this);

NibJS.define('standalone', function(nibjs) {
  nibjs.register('./index', function(exports, require) {
    var App, StringUtils;
    App = {
      runTests: function() {
        $("body").append(StringUtils.pre("This is why 'nibjs --standalone' exists!"));
        return true;
      }
    };
    StringUtils = {
      pre: function(what) {
        return "<pre>" + what + "</pre>";
      }
    };
    exports.StringUtils = StringUtils;
    return exports.App = App;
  });
  return nibjs.require('./index');
});
