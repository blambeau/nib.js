begin

  desc "Build spec fixtures from coffee to js"
  task :build_spec_fixture do
    shell_safe_exec("./bin/nibjs --coffee --uglify --libname=fixture --output=test/spec/fixture.js test/spec/fixture")
  end
  
  desc "Run spec examples"
  task :spec_test => :build_spec_fixture do
    shell_safe_exec("coffee tasks/run_specs.coffee")
  end

ensure
  task :spec => [:spec_test]
  task :test => [:spec_test]
end
