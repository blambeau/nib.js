# We include string utilities under Utils
{StringUtils} = require('./StringUtils')

# This is the main application, which is able to say hello to the 
# world.
exports.Foo = {
  
  sayHello: (who)->
    "Hello #{StringUtils.upcase(who)}"
  
}
