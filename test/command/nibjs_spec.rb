require File.expand_path('../scenarios', __FILE__)
describe "nibjs command" do
  
  def nibjs_real(*args)
    nibjs = File.expand_path('../../../bin/nibjs', __FILE__)
    `#{nibjs} #{args.flatten.join(' ')}`
  end
  
  def nibjs(*args)
    require File.expand_path('../../../lib/nibjs/main', __FILE__)
    command = NibJS::Main.new
    command.output = []
    command.run(args.flatten)
    command.output.join('')
  end
  
  it 'should have a --version' do
    x = nibjs_real %w{--version}
    x.should =~ /(c)/
  end
  
  it 'should have a --help' do
    x = nibjs_real %w{--help}
    x.should =~ /DESCRIPTION/
  end
  
  NibJS::Scenarios.new.common_tests_with_index('.js') do |options, i|

    it "should behave as expected on #{i}" do
      nibjs(options).should == File.read(File.expand_path("../#{i}.exp", __FILE__))
    end

  end

  NibJS::Scenarios.new.common_tests_with_index('.coffee') do |options, i|

    it "should behave as expected on #{i}" do
      opts = ["--coffee"] + options 
      nibjs(opts).should == File.read(File.expand_path("../#{i}.exp", __FILE__))
    end
    
  end
  
  NibJS::Scenarios.new.coffee_tests_with_index do |options, i|

    it "should behave as expected on #{i}" do
      nibjs(options).should == File.read(File.expand_path("../#{i}.exp", __FILE__))
    end
    
  end
  
end