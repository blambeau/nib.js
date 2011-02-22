module NibJS
  class Scenarios
    
    def _(file)
      File.expand_path("../#{file}", __FILE__)
    end
    
    def common_tests_with_index(ext = '.js', &block)
      (0..100).each{|i| 
        source = _("../fixture#{ext}")
        name = "sc_common_#{i}"
        if self.respond_to?(name.to_sym)
          yield(self.send(name.to_sym, source), name)
        end
      }
    end
    
    def coffee_tests_with_index(&block)
      (0..100).each{|i| 
        source = _("../fixture.coffee")
        name = "sc_coffee_#{i}"
        if self.respond_to?(name.to_sym)
          yield(self.send(name.to_sym, source), name)
        end
      }
    end
    
    def sc_common_0(src)
      [ src ]
    end
    
    def sc_common_1(src)
      [ "--libname=FixtureApp", src ]
    end
    
    def sc_common_2(src)
      [ "--autorequire", src ]
    end
    
    def sc_common_3(src)
      [ "--libname=FixtureApp", "--autorequire", src ]
    end
    
    def sc_common_4(src)
      [ "--libname=FixtureApp", "--autorequire", "--uglify", src ]
    end
    
    def sc_common_5(src)
      [ "--header=#{_('header.js')}", "--uglify", src ]
    end
    
    def sc_coffee_1(src)
      [ "--libname=FixtureApp", "--coffee", src ]
    end
    
    def sc_coffee_2(src)
      [ "--libname=FixtureApp", "--coffee", "--join", src ]
    end
    
  end # class Scenarios
end # module NibJS
