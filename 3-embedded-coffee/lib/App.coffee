{StringUtils} = require('./StringUtils')

exports.App = {
  
  runTests: ()->
    $("body").append StringUtils.pre("Check 'nibjs --coffee --no-coffee-compile'")
    true
  
}
