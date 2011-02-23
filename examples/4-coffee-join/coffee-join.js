NibJS.define('coffee-join', function(nibjs) {
  nibjs.register('./index', function(exports, require) {
    var App, StringUtils;
    App = {
      runTests: function() {
        $("body").append(StringUtils.pre("'nibjs --join' option is for you!"));
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
