describe "Scoping in coffeescript", ->
  
  it "should respect scoping intuitiveness", ->
  
    fn = (unshared, shared)->
  
      Foo = {
      
        internal: ()->
          unshared = {}
          unshared.id = "internal" 
          shared.id = "internal"
      
      }
      Foo.internal()
  
    x = {}
    x.id = "external"
    y = {}
    y.id = "external"
    fn(x, y)
    expect(x.id).toEqual "external"
    expect(y.id).toEqual "internal"