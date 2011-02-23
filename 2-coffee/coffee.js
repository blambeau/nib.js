NibJS.define('coffee', function(nibjs) {
  nibjs.register('./App', function(exports, require) {
    var StringUtils;
    StringUtils = require('./StringUtils').StringUtils;
    return exports.App = {
      runTests: function() {
        $("body").append(StringUtils.pre("Have a look at 'nibjs --coffee'"));
        return true;
      }
    };
  });
  nibjs.register('./index', function(exports, require) {
    exports.StringUtils = require('./StringUtils').StringUtils;
    return exports.App = require('./App').App;
  });
  nibjs.register('./StringUtils', function(exports, require) {
    return exports.StringUtils = {
      pre: function(what) {
        return "<pre>" + what + "</pre>";
      }
    };
  });
  return nibjs.require('./index');
});
