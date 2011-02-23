{StringUtils} = require('./StringUtils')

exports.App = {
  
  runTests: ()->
    $("#hello").append "<h1>#{StringUtils.upcase('check')} 'nibjs --coffee --no-coffee-compile'</h1>"
    true
  
}
