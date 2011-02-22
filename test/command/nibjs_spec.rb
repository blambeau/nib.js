require File.expand_path('../scenarios', __FILE__)
describe "nibjs command" do
  
  def nibjs(*args)
    nibjs = File.expand_path('../../../bin/nibjs', __FILE__)
    `#{nibjs} #{args.flatten.join(' ')}`
  end
  
  it 'should have a --version' do
    x = nibjs %w{--version}
    x.should =~ /(c)/
  end
  
  it 'should have a --help' do
    x = nibjs %w{--help}
    x.should =~ /DESCRIPTION/
  end
  
  NibJS::Scenarios.new.each_with_index do |options, i|

    it "should behave as expected on scenario n°#{i}" do
      nibjs(options).should == File.read(File.expand_path("../sc#{i}.exp", __FILE__))
    end

  end
  
end