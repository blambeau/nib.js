require "fileutils"

desc "Build dist/nibjs-#{$gemspec.version}.js" 
task :dist do
  target = "dist/nibjs-#{$gemspec.version}.js"
  shell_safe_exec("cat src/nibjs.coffee | coffee --bare --compile --stdio > #{target}")

  code = ""
  code += "(function(exports){\n"
  code += File.read(target).gsub(/^/m, "  ")
  code += "}).call(this, this)"
  
  File.open(target, "w"){|io| io << code}
end