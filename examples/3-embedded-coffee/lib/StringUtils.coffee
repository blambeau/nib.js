#
# This module exports string utilities under StringUtils.
#
# Example:
#
#   {SU} = require './StringUtils'
#   SU.upcase 'Hello World!'
#
#
exports.StringUtils = {
  
  upcase: (what)->
    what.toUpperCase()
  
}
