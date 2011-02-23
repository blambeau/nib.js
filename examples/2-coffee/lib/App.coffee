{StringUtils} = require('./StringUtils')

exports.App = {
  
  runTests: ()->
    $("#hello").append "<h1>Have a #{StringUtils.upcase('look at')} 'nibjs --coffee'</h1>"
    true
  
}