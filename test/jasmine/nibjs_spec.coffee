global.NibJS = require('../nibjs').NibJS

describe "NibJS", ->

  it 'should support register / start / query scenario', ->
    ran = null
    fn = ()->
      ran = "Hello world!"
      
    # Mark it as ready
    NibJS.ready(fn)

    # Start it now
    NibJS.start()
    expect( ran ).toEqual "Hello world!"
    
    # Verify that it is running
    expect(NibJS.isRunning("Hello world!")).toEqual true
    
  it 'should support embedding .js applications in browser', ->
    require('../fixture.min')
    
    # Require it
    fix = NibJS.require('fixture')
    expect(fix).toBeDefined
    expect(fix.App).toBeDefined
    expect(fix.Dependent).toBeDefined
    
    # Check it
    expect((new fix.App).say_hello()).toEqual "Hello from App"
    expect((new fix.Dependent).say_hello()).toEqual "Hello from Dependent"
