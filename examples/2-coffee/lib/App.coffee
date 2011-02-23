{StringUtils} = require('./StringUtils')

exports.App = {
  
  runTests: ()->
    $("body").append StringUtils.pre("Have a look at 'nibjs --coffee'")
    true
  
}