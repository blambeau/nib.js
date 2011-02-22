module NibJS
  class Scenarios
    include Enumerable
    
    def _(file)
      File.expand_path("../#{file}", __FILE__)
    end
    
    def each
      (0...100).each{|i|
        meth = :"sc#{i}"
        if self.respond_to?(meth)
          yield(self.send(meth))
        end
      }
    end
    
    def sc0
      [ _('../fixture.js') ]
    end
    
    def sc1
      [ 
        "--libname=FixtureApp",
        _('../fixture.js') 
      ]
    end
    
    def sc2
      [ 
        "--autorequire",
        _('../fixture.js'),
      ]
    end
    
    def sc3
      [ 
        "--libname=FixtureApp",
        "--autorequire",
        _('../fixture.js') 
      ]
    end
    
    
  end # class Scenarios
end # module NibJS
