var StringUtils = require('./StringUtils').StringUtils;
exports.App = {
  
  runTests: function(){
    $("body").append("<h1>NibJS " + StringUtils.upcase("rocks!") + "</h1>");
    return true;
  }
  
};
