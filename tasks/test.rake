begin
  
  desc "Compile test/nibjs.js"
  task :"test:dist" do
    dist(_('test/nibjs.js'))
  end
  
  desc "Compile test/fixture.js" 
  task :"test:fixture" do
    shell_safe_exec("coffee --compile --bare -o #{_('test/fixture.js')} #{_('test/fixture.coffee')}")
  end
  
  begin
    require "rspec/core/rake_task"
    desc "Run RSpec code examples"
    RSpec::Core::RakeTask.new(:"test:rspec" => :"test:fixture") do |t|
      t.pattern = "test/command/*_spec.rb"
      t.rspec_opts = ["--color", "--backtrace"]
    end
  rescue LoadError => ex
    task :"test:rspec" do
      abort 'rspec is not available. In order to run spec, you must: gem install rspec'
    end
  end

  desc "Compile test/fixture.min.js"
  task :"test:fixture.min" => :"test:fixture" do
    require "fileutils"
    fix = _('test/fixture.min.js')
    FileUtils.rm_rf fix
    shell_safe_exec("./bin/nibjs --libname=fixture --output=#{fix} test/fixture.js")
  end
  
  desc "Run Jasmine spec examples"
  task :"test:jasmine" do
    shell_safe_exec("coffee #{_('test/jasmine/run.coffee')}")
  end

  desc "Run integration tests"
  task :"test:integration" do
    shell_safe_exec("coffee --compile #{_('test/integration')}")
    puts "#"*100
    puts "Please open the URL below in your browser"
    puts "#"*100
    puts shell_safe_exec("ruby #{_('test/integration/integration_test.rb')}").inspect
  end
  
  desc "Bootstrap the test suite (rebuild command/*.exp)"
  task :"test:bootstrap" => :"test:fixture" do
    require _("test/command/scenarios")

    def boot_nibjs(options, i)
      output = _("test/command/sc#{i}.exp")
      nibjs(options, "--output=#{output}")
    end
    
    NibJS::Scenarios.new.each_with_index{|options, i|
      boot_nibjs(options, i)
    }
  end
  
ensure
  task :test => :"test:dist"
  task :test => :"test:fixture"
  task :test => :"test:rspec"
  task :test => :"test:jasmine"
  task :test => :"test:integration"
end
