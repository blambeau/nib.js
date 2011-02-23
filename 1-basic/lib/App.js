var StringUtils = require('./StringUtils').StringUtils;
exports.App = {
  
  runTests: function(){
    $("body").append(StringUtils.pre("nibjs --output jsapp.js lib"));
    return true;
  }
  
};
