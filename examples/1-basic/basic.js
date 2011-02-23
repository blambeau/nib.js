NibJS.define('basic', function(nibjs) {
  nibjs.register('./App', function(exports, require) {
    var StringUtils = require('./StringUtils').StringUtils;
    exports.App = {
      
      runTests: function(){
        $("body").append(StringUtils.pre("nibjs --output jsapp.js lib"));
        return true;
      }
      
    };
  });
  nibjs.register('./index', function(exports, require) {
    exports.StringUtils = require('./StringUtils').StringUtils;
    exports.App = require('./App').App;
  });
  nibjs.register('./StringUtils', function(exports, require) {
    exports.StringUtils = {
      
      pre: function(what) {
        return "<pre>" + what + "</pre>";
      }
      
    };
  });
  return nibjs.require('./index');
});
