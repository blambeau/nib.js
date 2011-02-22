begin
  
  desc "Compile test/nibjs.js"
  task :build_test_dist do
    dist(_('test/nibjs.js'))
  end
  
  desc "Compile test/fixture.js"
  task :build_fixture_js do
    require "fileutils"
    fix = _('test/fixture.js')
    FileUtils.rm_rf fix
    shell_safe_exec("./bin/nibjs --coffee --uglify --libname=fixture --output=#{fix} test/fixture.coffee")
  end
  
  desc "Run spec examples"
  task :"test:spec" => [:build_test_dist, :build_fixture_js] do
    shell_safe_exec("coffee #{_('tasks/run_specs.coffee')}")
  end

  desc "Run integration tests"
  task :"test:integration" => [:build_test_dist, :build_fixture_js] do
    shell_safe_exec("coffee --compile #{_('test/integration')}")
    puts "#"*100
    puts "Please open the URL below in your browser"
    puts "#"*100
    puts shell_safe_exec("ruby #{_('test/integration/integration_test.rb')}").inspect
  end

ensure
  task :test => :build_test_dist
  task :test => :"test:spec"
  task :test => :"test:integration"
end
