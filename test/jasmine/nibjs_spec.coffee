global.NibJS = require('../nibjs').NibJS

describe "NibJS", ->

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
    
  it 'should has a hasPackage helper method', ->
    require('../fixture.min')
    expect(NibJS.hasPackage('fixture')).toEqual true
    expect(NibJS.hasPackage('no such one')).toEqual false

  it 'should raise with a friendly message on external require error', ->
    lambda = ->
      NibJS.require('no such one')
    expect(lambda).toThrow(NibJS.Exception)
    try 
      lambda()
    catch err
      expect(err.message).toMatch /no such one/