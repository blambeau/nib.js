begin
  
  desc "Builds the integration test" 
  task :build_integration_test do
    shell_safe_exec("coffee --compile test/integration")
  end
  
  desc "Run integration tests"
  task :integration_test => :build_integration_test do
    puts "#"*100
    puts "Please open the URL below in your browser"
    puts "#"*100
    puts shell_safe_exec("ruby test/integration/integration_test.rb").inspect
  end
  
ensure
  desc "integration"
  task :test => [:integration_test]
end

