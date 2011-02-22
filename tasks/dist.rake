require "fileutils"

desc "Build dist/nibjs-#{$gemspec.version}.js" 
task :dist do

  # compile
  target = _("dist/nibjs-#{$gemspec.version}.js")
  dist(target)
  
  # minimize now
  target2 = _("dist/nibjs-#{$gemspec.version}.min.js")
  shell_safe_exec("uglifyjs #{target} > #{target2}")
  
end