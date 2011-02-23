NibJS.define 'embedded-coffee', (nibjs)->
  nibjs.register './App', (exports, require)->
    {StringUtils} = require('./StringUtils')
    
    exports.App = {
      
      runTests: ()->
        $("body").append StringUtils.pre("Check 'nibjs --coffee --no-coffee-compile'")
        true
      
    }
  
  nibjs.register './index', (exports, require)->
    exports.StringUtils = require('./StringUtils').StringUtils
    exports.App = require('./App').App
  
  nibjs.register './StringUtils', (exports, require)->
    exports.StringUtils = {
      
      pre: (what)->
        "<pre>#{what}</pre>"
      
    }

  nibjs.require './index'
