/* We include string utilities under Utils */
Utils = require('./StringUtils').StringUtils;

/* This is the main application, which is able to say hello to the 
 * world. */
exports.Foo = {
  
  sayHello: function(who){
    return "Hello " + Utils.upcase(who);
  }
  
};
