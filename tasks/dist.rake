require "fileutils"

desc "Build dist/nibjs-#{$gemspec.version}.js" 
task :dist do

  # compile
  target = "dist/nibjs-#{$gemspec.version}.js"
  shell_safe_exec("cat src/nibjs.coffee | coffee --bare --compile --stdio > #{target}")
  code = ""
  code += File.read("LICENCE.js")
  code += "(function(exports){\n"
  code += File.read(target).gsub(/^/m, "  ")
  code += "}).call(this, this)"
  File.open(target, "w"){|io| io << code}
  
  # minimize now
  target2 = "dist/nibjs-#{$gemspec.version}.min.js"
  shell_safe_exec("uglifyjs #{target} > #{target2}")
  
end