NibJS.TestSuite = {
  
  tests: [
    '1-basic',
    '2-coffee'
  ],
  
  indexOf: (test)->
    for t, i in NibJS.TestSuite.tests
      return i if t==test
    return null
    
  findNext: ()->
    loc = window.location
    if loc.hash? and loc.hash != ""
      test  = loc.hash.substring(1)
      index = NibJS.TestSuite.indexOf(test)
      if index? 
        next = NibJS.TestSuite.tests[index + 1]
  
  runNext: ()->
    next = NibJS.TestSuite.findNext()
    if next?
      moveNext = ->
        window.location = "../#{next}/index.html"
      setTimeout(moveNext, 1000)
  
  runOne: (app)=>
    runit = ()->
      try
        ok = app.runTests()
        $("#feedback img").attr 'src', "../test-#{ok}.png"
        NibJS.TestSuite.runNext()
      catch err
        $("body").append "<p>#{err.message}</p>"
        $("#feedback img").attr 'src', "../test-false.png"
        throw err
    setTimeout runit, 1500
  
}
