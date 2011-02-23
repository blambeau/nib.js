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
