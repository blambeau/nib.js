module NibJS
  module Version
  
    MAJOR = 1
    MINOR = 2
    TINY  = 0
  
    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end
  
  end 
  VERSION = Version.to_s
end
