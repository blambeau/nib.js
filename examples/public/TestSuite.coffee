TestSuite = {
  
  tests: [
    '1-basic',
    '2-coffee',
    '3-embedded-coffee',
    '4-coffee-join'
  ],
  
  indexOf: (test)->
    for t, i in TestSuite.tests
      return i if t==test
    return null
    
  findNext: ()->
    loc = window.location
    if loc.hash? and loc.hash != ""
      test  = loc.hash.substring(1)
      index = TestSuite.indexOf(test)
      if index? 
        next = TestSuite.tests[index + 1]
  
  runNext: ()->
    next = TestSuite.findNext()
    if next?
      moveNext = ->
        window.location = "../#{next}/index.html##{next}"
      setTimeout(moveNext, 1000)
  
  runOne: (app)=>
    runit = ()->
      try
        ok = app.runTests()
        $("#feedback img").attr 'src', "../public/test-#{ok}.png"
        TestSuite.runNext()
      catch err
        $("body").append "<p>#{err.message}</p>"
        $("#feedback img").attr 'src', "../public/test-false.png"
        throw err
    setTimeout runit, 1000
  
}
