/**
 * nib.js - [Java/Coffee]script application packager from node.js conventions
 * 
 * Copyright 2011, Bernard Lambeau
 * Released under the MIT License
 * http://github.com/blambeau/nib.js
 */
(function(exports){
  var Builder;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  exports.NibJS = {
    pkgBuilders: [],
    packages: [],
    define: function(name, buildFn) {
      return NibJS.pkgBuilders[name] = buildFn;
    },
    require: function(name) {
      var _base, _ref;
      return (_ref = (_base = NibJS.packages)[name]) != null ? _ref : _base[name] = NibJS.pkgBuilders[name](new Builder());
    },
    pending: [],
    running: [],
    ready: function(fn) {
      return NibJS.pending.push(fn);
    },
    start: function() {
      var fn, _i, _len, _ref;
      _ref = NibJS.pending;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fn = _ref[_i];
        NibJS.running.push(fn());
      }
      return NibJS.pending = [];
    },
    isRunning: function(fn) {
      var c, _i, _len, _ref;
      _ref = NibJS.running;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        if (c === fn) {
          return true;
        }
      }
      return false;
    }
  };
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
      exports = {};
      this.builders[file](exports, this.require);
      return exports;
    };
    return Builder;
  })();
}).call(this, this)