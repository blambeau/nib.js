begin
  
  desc "Compile test/nibjs.js"
  task :"test:dist" do
    dist(_('test/nibjs.js'))
  end
  
  desc "Compile test/fixture.js"
  task :"test:fixture" do
    require "fileutils"
    fix = _('test/fixture.js')
    FileUtils.rm_rf fix
    shell_safe_exec("./bin/nibjs --coffee --uglify --libname=fixture --output=#{fix} test/fixture.coffee")
  end
  
  desc "Run integration tests"
  task :"test:integration" => [:"test:dist", :"test:fixture"] do
    shell_safe_exec("coffee --compile #{_('test/integration')}")
    puts "#"*100
    puts "Please open the URL below in your browser"
    puts "#"*100
    puts shell_safe_exec("ruby #{_('test/integration/integration_test.rb')}").inspect
  end
  
  desc "Run Jasmine spec examples"
  task :"test:jasmine" => [:"test:dist", :"test:fixture"] do
    shell_safe_exec("coffee #{_('test/jasmine/run.coffee')}")
  end

  begin
    require "rspec/core/rake_task"
    desc "Run RSpec code examples"
    RSpec::Core::RakeTask.new(:"test:rspec") do |t|
      t.pattern = "test/command/*_spec.rb"
      t.rspec_opts = ["--color", "--backtrace"]
    end
  rescue LoadError => ex
    task :"test:rspec" do
      abort 'rspec is not available. In order to run spec, you must: gem install rspec'
    end
  end

ensure
  task :test => :"test:dist"
  task :test => :"test:jasmine"
  task :test => :"test:rspec"
  task :test => :"test:integration"
end
