def each_example
  Dir[_('examples/*')].each{|dir|
    next unless File.directory?(dir)
    next if File.basename(dir) == "public"
    File.basename(dir) =~ /\d-(.*)$/
    js_file = File.join(dir, "#{$1}.js")
    yield(dir, js_file)
  }
end

desc "Cleans the examples test suite"
task :"examples:clean" do
  require 'fileutils'
  FileUtils.rm_rf _('examples/public/TestSuite.js')
  each_example{|dir, js_file| FileUtils.rm_rf js_file}
end

desc "Rebuilds the whole examples test suite" 
task :"examples:build" => :"examples:clean" do
  shell_safe_exec("coffee --compile --bare #{_('examples/public/TestSuite.coffee')}")
  dist(_('examples/public/nibjs.js'))
  each_example do |dir, js_file|
    shell_safe_exec(File.join(dir, "build"))
  end
end