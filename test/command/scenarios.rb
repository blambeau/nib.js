module NibJS
  class Scenarios
    include Enumerable
    
    def _(file)
      File.expand_path("../#{file}", __FILE__)
    end
    
    def each
      yield(sc1)
      yield(sc2)
    end
    
    def sc1
      [ _('../fixture.js') ]
    end
    
    def sc2
      [ 
        "--libname=FixtureApp",
        _('../fixture.js') 
      ]
    end
    
  end # class Scenarios
end # module NibJS
