var StringUtils = require('./StringUtils').StringUtils;
exports.App = {
  
  runTests: function(){
    $("body").append(StringUtils.pre("nibjs --libname=jsapp --output=jsapp.js lib"));
    return true;
  }
  
};
