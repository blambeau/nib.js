module NibJS
  class Scenarios
    
    def _(file)
      File.expand_path("../#{file}", __FILE__)
    end
    
    def each_with_index(ext = '.js')
      (0...100).each{|i|
        meth = :"sc#{i}"
        if self.respond_to?(meth)
          source = _("../fixture#{ext}")
          yield(self.send(meth, source), i)
        end
      }
    end
    
    def sc0(src)
      [ src ]
    end
    
    def sc1(src)
      puts "On sc1: #{src}"
      [ "--libname=FixtureApp", src ]
    end
    
    def sc2(src)
      [ "--autorequire", src ]
    end
    
    def sc3(src)
      [ "--libname=FixtureApp", "--autorequire", src ]
    end
    
    def sc4(src)
      [ "--libname=FixtureApp", "--autorequire", "--uglify", src ]
    end
    
    def sc5(src)
      [ "--header=#{_('header.js')}", "--uglify", src ]
    end
    
    
  end # class Scenarios
end # module NibJS
